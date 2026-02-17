import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AppDatabase {
  AppDatabase({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _dbName = 'rz_audit.db';
  static const _dbVersion = 1;
  static const _keyName = 'rz_db_key';

  final FlutterSecureStorage _secureStorage;
  Database? _db;

  Future<Database> database() async {
    if (_db != null) {
      return _db!;
    }
    final docs = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docs.path, _dbName);
    final key = await _readOrCreateKey();
    _db = await openDatabase(
      dbPath,
      password: key,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _migrate(db, oldVersion, newVersion);
      },
    );
    return _db!;
  }

  Future<String> _readOrCreateKey() async {
    var key = await _secureStorage.read(key: _keyName);
    if (key != null) {
      return key;
    }
    key = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    await _secureStorage.write(key: _keyName, value: key);
    return key;
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE context_profiles(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        parameters_json TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE assessments(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        org TEXT NOT NULL,
        location TEXT NOT NULL,
        context_profile_id TEXT NOT NULL,
        status TEXT NOT NULL,
        catalog_version TEXT NOT NULL,
        responsible_role TEXT,
        assessment_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE domains(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE topics(
        id TEXT PRIMARY KEY,
        domain_id TEXT NOT NULL,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE control_items(
        id TEXT PRIMARY KEY,
        domain_id TEXT NOT NULL,
        topic_id TEXT NOT NULL,
        title TEXT NOT NULL,
        objective TEXT NOT NULL,
        question TEXT NOT NULL,
        scoring_model TEXT NOT NULL,
        anchors_json TEXT NOT NULL,
        evidence_requirements_json TEXT NOT NULL,
        risk_relevant INTEGER NOT NULL,
        catalog_version TEXT NOT NULL,
        is_active INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE norm_references(
        id TEXT PRIMARY KEY,
        standard_name TEXT NOT NULL,
        standard_version TEXT NOT NULL,
        ref_code TEXT NOT NULL,
        ref_text_short TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE control_norm_map(
        control_item_id TEXT NOT NULL,
        norm_reference_id TEXT NOT NULL,
        PRIMARY KEY(control_item_id, norm_reference_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE item_answers(
        id TEXT PRIMARY KEY,
        assessment_id TEXT NOT NULL,
        control_item_id TEXT NOT NULL,
        score_type TEXT NOT NULL,
        fulfilment_enum TEXT,
        maturity_level INTEGER,
        notes TEXT NOT NULL,
        answered_by TEXT NOT NULL,
        answered_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE findings(
        id TEXT PRIMARY KEY,
        assessment_id TEXT NOT NULL,
        control_item_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        severity TEXT NOT NULL,
        status TEXT NOT NULL,
        action TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE risks(
        id TEXT PRIMARY KEY,
        assessment_id TEXT NOT NULL,
        finding_id TEXT NOT NULL,
        likelihood INTEGER NOT NULL,
        impact INTEGER NOT NULL,
        score INTEGER NOT NULL,
        risk_class TEXT NOT NULL,
        rationale TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE evidence(
        id TEXT PRIMARY KEY,
        assessment_id TEXT NOT NULL,
        linked_entity_type TEXT NOT NULL,
        linked_entity_id TEXT NOT NULL,
        file_path TEXT NOT NULL,
        file_name TEXT NOT NULL,
        mime_type TEXT NOT NULL,
        file_hash TEXT,
        hash_alg TEXT,
        source TEXT NOT NULL,
        owner TEXT NOT NULL,
        confidentiality TEXT NOT NULL,
        valid_until TEXT,
        status TEXT NOT NULL,
        notes TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE audit_log(
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        actor TEXT NOT NULL,
        event_type TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        before_json TEXT,
        after_json TEXT,
        chain_hash_prev TEXT,
        chain_hash_this TEXT
      )
    ''');

    await db.insert('context_profiles', {
      'id': 'ctx-default',
      'name': 'Standard On-Prem',
      'parameters_json': jsonEncode({
        'likelihoodAnchors': {
          '1': 'Sehr unwahrscheinlich',
          '5': 'Sehr wahrscheinlich',
        },
        'impactAnchors': {
          '1': 'Geringe Auswirkung',
          '5': 'Massive Geschäftsunterbrechung',
        },
      }),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _migrate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) {
      await _createSchema(db);
    }
  }

  Future<void> resetForTest() async {
    final db = await database();
    for (final table in [
      'item_answers',
      'findings',
      'risks',
      'evidence',
      'audit_log',
      'assessments',
      'control_norm_map',
      'norm_references',
      'control_items',
      'topics',
      'domains',
    ]) {
      await db.delete(table);
    }
  }

  Assessment toAssessment(Map<String, Object?> row) => Assessment(
        id: row['id']! as String,
        name: row['name']! as String,
        org: row['org']! as String,
        location: row['location']! as String,
        contextProfileId: row['context_profile_id']! as String,
        status: AssessmentStatus.values.byName(row['status']! as String),
        catalogVersion: row['catalog_version']! as String,
        responsibleRole: row['responsible_role'] as String?,
        assessmentDate: (row['assessment_date'] as String?) != null
            ? DateTime.parse(row['assessment_date']! as String)
            : null,
        createdAt: DateTime.parse(row['created_at']! as String),
        updatedAt: DateTime.parse(row['updated_at']! as String),
        completedAt: (row['completed_at'] as String?) != null
            ? DateTime.parse(row['completed_at']! as String)
            : null,
      );

  ItemAnswer toItemAnswer(Map<String, Object?> row) => ItemAnswer(
        id: row['id']! as String,
        assessmentId: row['assessment_id']! as String,
        controlItemId: row['control_item_id']! as String,
        scoreType: ScoringModel.values.byName(row['score_type']! as String),
        fulfilmentEnum: (row['fulfilment_enum'] as String?) == null
            ? null
            : Fulfilment.values.byName(row['fulfilment_enum']! as String),
        maturityLevel: row['maturity_level'] as int?,
        notes: row['notes']! as String,
        answeredBy: row['answered_by']! as String,
        answeredAt: DateTime.parse(row['answered_at']! as String),
      );

  ControlItem toControlItem(Map<String, Object?> row) => ControlItem(
        id: row['id']! as String,
        domainId: row['domain_id']! as String,
        topicId: row['topic_id']! as String,
        title: row['title']! as String,
        objective: row['objective']! as String,
        question: row['question']! as String,
        scoringModel: ScoringModel.values.byName(row['scoring_model']! as String),
        anchorsJson: row['anchors_json']! as String,
        evidenceRequirementsJson: row['evidence_requirements_json']! as String,
        riskRelevant: (row['risk_relevant']! as int) == 1,
        catalogVersion: row['catalog_version']! as String,
        isActive: (row['is_active']! as int) == 1,
      );

  Finding toFinding(Map<String, Object?> row) => Finding(
        id: row['id']! as String,
        assessmentId: row['assessment_id']! as String,
        controlItemId: row['control_item_id']! as String,
        title: row['title']! as String,
        description: row['description']! as String,
        type: FindingType.values.byName(row['type']! as String),
        severity: Severity.values.byName(row['severity']! as String),
        status: FindingStatus.values.byName(row['status']! as String),
        action: row['action'] as String?,
        createdAt: DateTime.parse(row['created_at']! as String),
        updatedAt: DateTime.parse(row['updated_at']! as String),
      );

  RiskRecord toRisk(Map<String, Object?> row) => RiskRecord(
        id: row['id']! as String,
        assessmentId: row['assessment_id']! as String,
        findingId: row['finding_id']! as String,
        likelihood: row['likelihood']! as int,
        impact: row['impact']! as int,
        score: row['score']! as int,
        riskClass: RiskClass.values.byName(row['risk_class']! as String),
        rationale: row['rationale']! as String,
        createdAt: DateTime.parse(row['created_at']! as String),
        updatedAt: DateTime.parse(row['updated_at']! as String),
      );

  Evidence toEvidence(Map<String, Object?> row) => Evidence(
        id: row['id']! as String,
        assessmentId: row['assessment_id']! as String,
        linkedEntityType: EntityType.values.byName(row['linked_entity_type']! as String),
        linkedEntityId: row['linked_entity_id']! as String,
        filePath: row['file_path']! as String,
        fileName: row['file_name']! as String,
        mimeType: row['mime_type']! as String,
        fileHash: row['file_hash'] as String?,
        hashAlg: row['hash_alg'] as String?,
        source: row['source']! as String,
        owner: row['owner']! as String,
        confidentiality: row['confidentiality']! as String,
        validUntil: (row['valid_until'] as String?) == null
            ? null
            : DateTime.parse(row['valid_until']! as String),
        status: EvidenceStatus.values.byName(row['status']! as String),
        notes: row['notes']! as String,
        createdAt: DateTime.parse(row['created_at']! as String),
      );

  AuditLogEntry toAudit(Map<String, Object?> row) => AuditLogEntry(
        id: row['id']! as String,
        timestamp: DateTime.parse(row['timestamp']! as String),
        actor: row['actor']! as String,
        eventType: AuditEventType.values.byName(row['event_type']! as String),
        entityType: EntityType.values.byName(row['entity_type']! as String),
        entityId: row['entity_id']! as String,
        beforeJson: row['before_json'] as String?,
        afterJson: row['after_json'] as String?,
        chainHashPrev: row['chain_hash_prev'] as String?,
        chainHashThis: row['chain_hash_this'] as String?,
      );
}
