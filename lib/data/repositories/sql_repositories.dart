import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rz_checkliste_risikoanalyse/data/db/app_database.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/repositories/repositories.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SqlAssessmentRepository implements AssessmentRepository {
  SqlAssessmentRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Assessment?> getAssessment(String id) async {
    final db = await _db.database();
    final rows = await db.query('assessments', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) {
      return null;
    }
    return _db.toAssessment(rows.first);
  }

  @override
  Future<List<Assessment>> listAssessments() async {
    final db = await _db.database();
    final rows = await db.query('assessments', orderBy: 'updated_at DESC');
    return rows.map(_db.toAssessment).toList(growable: false);
  }

  @override
  Future<void> upsertAssessment(Assessment assessment) async {
    final db = await _db.database();
    await db.insert(
      'assessments',
      {
        'id': assessment.id,
        'name': assessment.name,
        'org': assessment.org,
        'location': assessment.location,
        'context_profile_id': assessment.contextProfileId,
        'status': assessment.status.name,
        'catalog_version': assessment.catalogVersion,
        'responsible_role': assessment.responsibleRole,
        'assessment_date': assessment.assessmentDate?.toIso8601String(),
        'created_at': assessment.createdAt.toIso8601String(),
        'updated_at': assessment.updatedAt.toIso8601String(),
        'completed_at': assessment.completedAt?.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateStatus(String id, AssessmentStatus status) async {
    final db = await _db.database();
    await db.update(
      'assessments',
      {
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
        'completed_at':
            status == AssessmentStatus.completed ? DateTime.now().toIso8601String() : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class SqlCatalogRepository implements CatalogRepository {
  SqlCatalogRepository(this._db);

  final AppDatabase _db;

  @override
  Future<String> exportCatalogJson() async {
    final db = await _db.database();
    final domains = await db.query('domains');
    final topics = await db.query('topics');
    final items = await db.query('control_items');
    final refs = await db.query('norm_references');
    final mappings = await db.query('control_norm_map');
    return jsonEncode({
      'domains': domains,
      'topics': topics,
      'items': items,
      'normReferences': refs,
      'controlNormMap': mappings,
    });
  }

  @override
  Future<void> importCatalogJson(String jsonText) async {
    final db = await _db.database();
    final parsed = jsonDecode(jsonText) as Map<String, dynamic>;

    Future<void> insertList(DatabaseExecutor executor, String table, List<dynamic> rows) async {
      for (final row in rows) {
        await executor.insert(
          table,
          Map<String, dynamic>.from(row as Map),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await db.transaction((txn) async {
      await txn.delete('control_norm_map');
      await txn.delete('norm_references');
      await txn.delete('control_items');
      await txn.delete('topics');
      await txn.delete('domains');
      await insertList(txn, 'domains', parsed['domains'] as List<dynamic>);
      await insertList(txn, 'topics', parsed['topics'] as List<dynamic>);
      await insertList(txn, 'control_items', parsed['items'] as List<dynamic>);
      await insertList(txn, 'norm_references', parsed['normReferences'] as List<dynamic>);
      await insertList(txn, 'control_norm_map', parsed['controlNormMap'] as List<dynamic>);
    });
  }

  Future<void> seedIfNeeded() async {
    final db = await _db.database();
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM domains')) ?? 0;
    if (count > 0) {
      return;
    }
    final jsonText = await rootBundle.loadString('assets/catalog_v1.json');
    await importCatalogJson(jsonText);
  }

  @override
  Future<List<ControlItem>> listAllItems() async {
    final db = await _db.database();
    final rows = await db.query('control_items', where: 'is_active = 1');
    return rows.map(_db.toControlItem).toList(growable: false);
  }

  @override
  Future<List<DomainEntity>> listDomains() async {
    final db = await _db.database();
    final rows = await db.query('domains', orderBy: 'name ASC');
    return rows
        .map(
          (r) => DomainEntity(
            id: r['id']! as String,
            name: r['name']! as String,
            description: r['description']! as String,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<ControlItem>> listItemsByDomain(String domainId) async {
    final db = await _db.database();
    final rows = await db.query(
      'control_items',
      where: 'domain_id = ? AND is_active = 1',
      whereArgs: [domainId],
      orderBy: 'title ASC',
    );
    return rows.map(_db.toControlItem).toList(growable: false);
  }

  @override
  Future<List<NormReference>> listNormReferencesForItem(String controlItemId) async {
    final db = await _db.database();
    final rows = await db.rawQuery(
      '''
      SELECT n.* FROM norm_references n
      JOIN control_norm_map m ON n.id = m.norm_reference_id
      WHERE m.control_item_id = ?
      ORDER BY n.standard_name ASC
      ''',
      [controlItemId],
    );
    return rows
        .map(
          (r) => NormReference(
            id: r['id']! as String,
            standardName: r['standard_name']! as String,
            standardVersion: r['standard_version']! as String,
            refCode: r['ref_code']! as String,
            refTextShort: r['ref_text_short']! as String,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<Topic>> listTopicsByDomain(String domainId) async {
    final db = await _db.database();
    final rows = await db.query('topics', where: 'domain_id = ?', whereArgs: [domainId]);
    return rows
        .map((r) => Topic(id: r['id']! as String, domainId: domainId, name: r['name']! as String))
        .toList(growable: false);
  }
}

class SqlAssessmentWorkRepository implements AssessmentWorkRepository {
  SqlAssessmentWorkRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<ItemAnswer>> listAnswers(String assessmentId, {String? domainId}) async {
    final db = await _db.database();
    if (domainId == null) {
      final rows = await db.query('item_answers', where: 'assessment_id = ?', whereArgs: [assessmentId]);
      return rows.map(_db.toItemAnswer).toList(growable: false);
    }

    final rows = await db.rawQuery(
      '''
      SELECT a.* FROM item_answers a
      JOIN control_items c ON a.control_item_id = c.id
      WHERE a.assessment_id = ? AND c.domain_id = ?
      ''',
      [assessmentId, domainId],
    );
    return rows.map(_db.toItemAnswer).toList(growable: false);
  }

  @override
  Future<List<Evidence>> listEvidence(String assessmentId) async {
    final db = await _db.database();
    final rows = await db.query('evidence', where: 'assessment_id = ?', whereArgs: [assessmentId]);
    return rows.map(_db.toEvidence).toList(growable: false);
  }

  @override
  Future<List<Finding>> listFindings(String assessmentId) async {
    final db = await _db.database();
    final rows = await db.query('findings', where: 'assessment_id = ?', whereArgs: [assessmentId]);
    return rows.map(_db.toFinding).toList(growable: false);
  }

  @override
  Future<List<RiskRecord>> listRisks(String assessmentId) async {
    final db = await _db.database();
    final rows = await db.query('risks', where: 'assessment_id = ?', whereArgs: [assessmentId]);
    return rows.map(_db.toRisk).toList(growable: false);
  }

  @override
  Future<void> upsertAnswer(ItemAnswer answer) async {
    final db = await _db.database();
    await db.insert(
      'item_answers',
      {
        'id': answer.id,
        'assessment_id': answer.assessmentId,
        'control_item_id': answer.controlItemId,
        'score_type': answer.scoreType.name,
        'fulfilment_enum': answer.fulfilmentEnum?.name,
        'maturity_level': answer.maturityLevel,
        'notes': answer.notes,
        'answered_by': answer.answeredBy,
        'answered_at': answer.answeredAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> upsertEvidence(Evidence evidence) async {
    final db = await _db.database();
    await db.insert(
      'evidence',
      {
        'id': evidence.id,
        'assessment_id': evidence.assessmentId,
        'linked_entity_type': evidence.linkedEntityType.name,
        'linked_entity_id': evidence.linkedEntityId,
        'file_path': evidence.filePath,
        'file_name': evidence.fileName,
        'mime_type': evidence.mimeType,
        'file_hash': evidence.fileHash,
        'hash_alg': evidence.hashAlg,
        'source': evidence.source,
        'owner': evidence.owner,
        'confidentiality': evidence.confidentiality,
        'valid_until': evidence.validUntil?.toIso8601String(),
        'status': evidence.status.name,
        'notes': evidence.notes,
        'created_at': evidence.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> upsertFinding(Finding finding) async {
    final db = await _db.database();
    await db.insert(
      'findings',
      {
        'id': finding.id,
        'assessment_id': finding.assessmentId,
        'control_item_id': finding.controlItemId,
        'title': finding.title,
        'description': finding.description,
        'type': finding.type.name,
        'severity': finding.severity.name,
        'status': finding.status.name,
        'action': finding.action,
        'created_at': finding.createdAt.toIso8601String(),
        'updated_at': finding.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> upsertRisk(RiskRecord risk) async {
    final db = await _db.database();
    await db.insert(
      'risks',
      {
        'id': risk.id,
        'assessment_id': risk.assessmentId,
        'finding_id': risk.findingId,
        'likelihood': risk.likelihood,
        'impact': risk.impact,
        'score': risk.score,
        'risk_class': risk.riskClass.name,
        'rationale': risk.rationale,
        'created_at': risk.createdAt.toIso8601String(),
        'updated_at': risk.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class SqlAuditRepository implements AuditRepository {
  SqlAuditRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> append(AuditLogEntry entry, {required bool useHashChain}) async {
    final db = await _db.database();
    await db.insert('audit_log', {
      'id': entry.id,
      'timestamp': entry.timestamp.toIso8601String(),
      'actor': entry.actor,
      'event_type': entry.eventType.name,
      'entity_type': entry.entityType.name,
      'entity_id': entry.entityId,
      'before_json': entry.beforeJson,
      'after_json': entry.afterJson,
      'chain_hash_prev': useHashChain ? entry.chainHashPrev : null,
      'chain_hash_this': useHashChain ? entry.chainHashThis : null,
    });
  }

  @override
  Future<String?> lastHash() async {
    final db = await _db.database();
    final rows = await db.query('audit_log', orderBy: 'timestamp DESC', limit: 1);
    if (rows.isEmpty) {
      return null;
    }
    return rows.first['chain_hash_this'] as String?;
  }

  @override
  Future<List<AuditLogEntry>> listByAssessment(String assessmentId) async {
    final db = await _db.database();
    final rows = await db.query(
      'audit_log',
      where: 'entity_id = ? OR before_json LIKE ? OR after_json LIKE ?',
      whereArgs: [assessmentId, '%$assessmentId%', '%$assessmentId%'],
      orderBy: 'timestamp ASC',
    );
    return rows.map(_db.toAudit).toList(growable: false);
  }
}
