import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rz_checkliste_risikoanalyse/application/assessment_orchestrator.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/repositories/repositories.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/audit_chain_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/finding_derivation_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/risk_engine.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('assessment -> answer -> finding/risk -> status', (_) async {
    final asmRepo = _MemAssessmentRepo();
    final catRepo = _MemCatalogRepo();
    final workRepo = _MemWorkRepo();
    final auditRepo = _MemAuditRepo();

    final orchestrator = AssessmentOrchestrator(
      assessmentRepository: asmRepo,
      catalogRepository: catRepo,
      workRepository: workRepo,
      auditRepository: auditRepo,
      findingDerivation: const FindingDerivationService(),
      riskEngine: const RiskEngine(),
      auditChain: const AuditChainService(),
      actor: 'tester',
    );

    final asm = await orchestrator.createAssessment(
      name: 'A1',
      org: 'Org',
      location: 'Site',
      contextProfileId: 'ctx',
      catalogVersion: 'v1',
    );

    await orchestrator.answerItem(
      assessment: asm,
      item: catRepo.items.first,
      scoreType: ScoringModel.fulfilment,
      fulfilment: Fulfilment.notFulfilled,
      maturityLevel: null,
      notes: 'Gap',
      answeredBy: 'tester',
      likelihood: 4,
      impact: 4,
      evidenceValid: false,
    );

    await orchestrator.updateAssessmentStatus(asm.id, AssessmentStatus.completed);

    expect((await asmRepo.getAssessment(asm.id))?.status, AssessmentStatus.completed);
    expect((await workRepo.listFindings(asm.id)).length, 1);
    expect((await workRepo.listRisks(asm.id)).single.score, 16);
    expect((await auditRepo.listByAssessment(asm.id)).isNotEmpty, isTrue);
  });
}

class _MemAssessmentRepo implements AssessmentRepository {
  final _data = <String, Assessment>{};

  @override
  Future<Assessment?> getAssessment(String id) async => _data[id];

  @override
  Future<List<Assessment>> listAssessments() async => _data.values.toList();

  @override
  Future<void> upsertAssessment(Assessment assessment) async {
    _data[assessment.id] = assessment;
  }

  @override
  Future<void> updateStatus(String id, AssessmentStatus status) async {
    final existing = _data[id]!;
    _data[id] = existing.copyWith(status: status, updatedAt: DateTime.now());
  }
}

class _MemCatalogRepo implements CatalogRepository {
  final items = [
    ControlItem(
      id: 'ci-1',
      domainId: 'd-1',
      topicId: 't-1',
      title: 'USV',
      objective: 'Obj',
      question: 'Q?',
      scoringModel: ScoringModel.fulfilment,
      anchorsJson: '{}',
      evidenceRequirementsJson: '{}',
      riskRelevant: true,
      catalogVersion: 'v1',
      isActive: true,
    )
  ];

  @override
  Future<String> exportCatalogJson() async => '{}';

  @override
  Future<void> importCatalogJson(String json) async {}

  @override
  Future<List<ControlItem>> listAllItems() async => items;

  @override
  Future<List<DomainEntity>> listDomains() async => const [];

  @override
  Future<List<ControlItem>> listItemsByDomain(String domainId) async => items;

  @override
  Future<List<NormReference>> listNormReferencesForItem(String controlItemId) async => const [];

  @override
  Future<List<Topic>> listTopicsByDomain(String domainId) async => const [];
}

class _MemWorkRepo implements AssessmentWorkRepository {
  final answers = <ItemAnswer>[];
  final findings = <Finding>[];
  final risks = <RiskRecord>[];
  final evidence = <Evidence>[];

  @override
  Future<List<ItemAnswer>> listAnswers(String assessmentId, {String? domainId}) async =>
      answers.where((a) => a.assessmentId == assessmentId).toList();

  @override
  Future<List<Evidence>> listEvidence(String assessmentId) async =>
      evidence.where((e) => e.assessmentId == assessmentId).toList();

  @override
  Future<List<Finding>> listFindings(String assessmentId) async =>
      findings.where((f) => f.assessmentId == assessmentId).toList();

  @override
  Future<List<RiskRecord>> listRisks(String assessmentId) async =>
      risks.where((r) => r.assessmentId == assessmentId).toList();

  @override
  Future<void> upsertAnswer(ItemAnswer answer) async {
    answers.add(answer);
  }

  @override
  Future<void> upsertEvidence(Evidence evidenceEntry) async {
    evidence.add(evidenceEntry);
  }

  @override
  Future<void> upsertFinding(Finding finding) async {
    findings.add(finding);
  }

  @override
  Future<void> upsertRisk(RiskRecord risk) async {
    risks.add(risk);
  }
}

class _MemAuditRepo implements AuditRepository {
  final entries = <AuditLogEntry>[];

  @override
  Future<void> append(AuditLogEntry entry, {required bool useHashChain}) async {
    entries.add(entry);
  }

  @override
  Future<String?> lastHash() async => entries.isEmpty ? null : entries.last.chainHashThis;

  @override
  Future<List<AuditLogEntry>> listByAssessment(String assessmentId) async =>
      entries.where((e) => e.entityId == assessmentId || (e.afterJson?.contains(assessmentId) ?? false)).toList();
}
