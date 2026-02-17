import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';

abstract class AssessmentRepository {
  Future<List<Assessment>> listAssessments();
  Future<Assessment?> getAssessment(String id);
  Future<void> upsertAssessment(Assessment assessment);
  Future<void> updateStatus(String id, AssessmentStatus status);
}

abstract class CatalogRepository {
  Future<List<DomainEntity>> listDomains();
  Future<List<Topic>> listTopicsByDomain(String domainId);
  Future<List<ControlItem>> listItemsByDomain(String domainId);
  Future<List<ControlItem>> listAllItems();
  Future<List<NormReference>> listNormReferencesForItem(String controlItemId);
  Future<void> importCatalogJson(String json);
  Future<String> exportCatalogJson();
}

abstract class AssessmentWorkRepository {
  Future<List<ItemAnswer>> listAnswers(String assessmentId, {String? domainId});
  Future<void> upsertAnswer(ItemAnswer answer);
  Future<List<Finding>> listFindings(String assessmentId);
  Future<void> upsertFinding(Finding finding);
  Future<List<RiskRecord>> listRisks(String assessmentId);
  Future<void> upsertRisk(RiskRecord risk);
  Future<List<Evidence>> listEvidence(String assessmentId);
  Future<void> upsertEvidence(Evidence evidence);
}

abstract class AuditRepository {
  Future<void> append(AuditLogEntry entry, {required bool useHashChain});
  Future<List<AuditLogEntry>> listByAssessment(String assessmentId);
  Future<String?> lastHash();
}
