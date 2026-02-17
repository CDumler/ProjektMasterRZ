import 'dart:convert';

import 'package:rz_checkliste_risikoanalyse/core/id.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/repositories/repositories.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/audit_chain_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/finding_derivation_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/risk_engine.dart';

class AssessmentOrchestrator {
  AssessmentOrchestrator({
    required this.assessmentRepository,
    required this.catalogRepository,
    required this.workRepository,
    required this.auditRepository,
    required this.findingDerivation,
    required this.riskEngine,
    required this.auditChain,
    required this.actor,
    this.useAuditHashChain = true,
  });

  final AssessmentRepository assessmentRepository;
  final CatalogRepository catalogRepository;
  final AssessmentWorkRepository workRepository;
  final AuditRepository auditRepository;
  final FindingDerivationService findingDerivation;
  final RiskEngine riskEngine;
  final AuditChainService auditChain;
  final String actor;
  final bool useAuditHashChain;

  Future<Assessment> createAssessment({
    required String name,
    required String org,
    required String location,
    required String contextProfileId,
    required String catalogVersion,
    String? responsibleRole,
  }) async {
    final now = DateTime.now();
    final assessment = Assessment(
      id: newId('asm'),
      name: name,
      org: org,
      location: location,
      contextProfileId: contextProfileId,
      status: AssessmentStatus.draft,
      catalogVersion: catalogVersion,
      createdAt: now,
      updatedAt: now,
      responsibleRole: responsibleRole,
      assessmentDate: now,
    );
    await assessmentRepository.upsertAssessment(assessment);
    await _audit(
      eventType: AuditEventType.create,
      entityType: EntityType.assessment,
      entityId: assessment.id,
      after: assessment.toJson(),
    );
    return assessment;
  }

  Future<void> updateAssessmentStatus(String assessmentId, AssessmentStatus status) async {
    final before = await assessmentRepository.getAssessment(assessmentId);
    await assessmentRepository.updateStatus(assessmentId, status);
    final after = await assessmentRepository.getAssessment(assessmentId);
    if (after != null) {
      await _audit(
        eventType: AuditEventType.statusChange,
        entityType: EntityType.assessment,
        entityId: assessmentId,
        before: before?.toJson(),
        after: after.toJson(),
      );
    }
  }

  Future<void> answerItem({
    required Assessment assessment,
    required ControlItem item,
    required ScoringModel scoreType,
    required Fulfilment? fulfilment,
    required int? maturityLevel,
    required String notes,
    required String answeredBy,
    int likelihood = 3,
    int impact = 3,
    bool evidenceValid = true,
  }) async {
    final answer = ItemAnswer(
      id: newId('ans'),
      assessmentId: assessment.id,
      controlItemId: item.id,
      scoreType: scoreType,
      fulfilmentEnum: fulfilment,
      maturityLevel: maturityLevel,
      notes: notes,
      answeredBy: answeredBy,
      answeredAt: DateTime.now(),
    );
    await workRepository.upsertAnswer(answer);
    await _audit(
      eventType: AuditEventType.create,
      entityType: EntityType.itemAnswer,
      entityId: answer.id,
      after: answer.toJson(),
    );

    if (!findingDerivation.shouldCreateFinding(item, answer)) {
      return;
    }

    final finding = Finding(
      id: newId('find'),
      assessmentId: assessment.id,
      controlItemId: item.id,
      title: 'Abweichung: ${item.title}',
      description: notes.isEmpty
          ? 'Automatisch aus Bewertung abgeleitet.'
          : 'Automatisch aus Bewertung abgeleitet. Notiz: $notes',
      type: findingDerivation.deriveType(answer, evidenceValid: evidenceValid),
      severity: findingDerivation.deriveSeverity(answer),
      status: FindingStatus.open,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await workRepository.upsertFinding(finding);
    await _audit(
      eventType: AuditEventType.create,
      entityType: EntityType.finding,
      entityId: finding.id,
      after: finding.toJson(),
    );

    final scoredRisk = riskEngine.calculate(likelihood: likelihood, impact: impact);
    final risk = RiskRecord(
      id: newId('risk'),
      assessmentId: assessment.id,
      findingId: finding.id,
      likelihood: likelihood,
      impact: impact,
      score: scoredRisk.score,
      riskClass: scoredRisk.riskClass,
      rationale: 'Aus Item ${item.id} via Finding ${finding.id} abgeleitet.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await workRepository.upsertRisk(risk);
    await _audit(
      eventType: AuditEventType.create,
      entityType: EntityType.riskRecord,
      entityId: risk.id,
      after: risk.toJson(),
    );
  }

  Future<void> addEvidence(Evidence evidence) async {
    await workRepository.upsertEvidence(evidence);
    await _audit(
      eventType: AuditEventType.create,
      entityType: EntityType.evidence,
      entityId: evidence.id,
      after: evidence.toJson(),
    );
  }

  Future<void> auditExport({
    required EntityType entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    await _audit(
      eventType: AuditEventType.export,
      entityType: entityType,
      entityId: entityId,
      after: payload,
    );
  }

  Future<void> _audit({
    required AuditEventType eventType,
    required EntityType entityType,
    required String entityId,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  }) async {
    final prev = useAuditHashChain ? await auditRepository.lastHash() : null;
    final draft = AuditLogEntry(
      id: newId('audit'),
      timestamp: DateTime.now(),
      actor: actor,
      eventType: eventType,
      entityType: entityType,
      entityId: entityId,
      beforeJson: before == null ? null : jsonEncode(before),
      afterJson: after == null ? null : jsonEncode(after),
      chainHashPrev: prev,
    );

    final entry = AuditLogEntry(
      id: draft.id,
      timestamp: draft.timestamp,
      actor: draft.actor,
      eventType: draft.eventType,
      entityType: draft.entityType,
      entityId: draft.entityId,
      beforeJson: draft.beforeJson,
      afterJson: draft.afterJson,
      chainHashPrev: prev,
      chainHashThis: useAuditHashChain ? auditChain.computeHash(draft, prevHash: prev) : null,
    );

    await auditRepository.append(entry, useHashChain: useAuditHashChain);
  }
}
