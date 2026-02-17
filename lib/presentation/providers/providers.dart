import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rz_checkliste_risikoanalyse/application/assessment_orchestrator.dart';
import 'package:rz_checkliste_risikoanalyse/data/db/app_database.dart';
import 'package:rz_checkliste_risikoanalyse/data/repositories/sql_repositories.dart';
import 'package:rz_checkliste_risikoanalyse/data/services/evidence_service.dart';
import 'package:rz_checkliste_risikoanalyse/data/services/export_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/audit_chain_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/finding_derivation_service.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/risk_engine.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final assessmentRepositoryProvider = Provider<SqlAssessmentRepository>(
  (ref) => SqlAssessmentRepository(ref.watch(databaseProvider)),
);

final catalogRepositoryProvider = Provider<SqlCatalogRepository>(
  (ref) => SqlCatalogRepository(ref.watch(databaseProvider)),
);

final workRepositoryProvider = Provider<SqlAssessmentWorkRepository>(
  (ref) => SqlAssessmentWorkRepository(ref.watch(databaseProvider)),
);

final auditRepositoryProvider = Provider<SqlAuditRepository>(
  (ref) => SqlAuditRepository(ref.watch(databaseProvider)),
);

final riskEngineProvider = Provider<RiskEngine>((_) => const RiskEngine());
final exportServiceProvider = Provider<ExportService>((_) => ExportService());
final evidenceServiceProvider = Provider<EvidenceService>((_) => EvidenceService());

final orchestratorProvider = Provider<AssessmentOrchestrator>(
  (ref) => AssessmentOrchestrator(
    assessmentRepository: ref.watch(assessmentRepositoryProvider),
    catalogRepository: ref.watch(catalogRepositoryProvider),
    workRepository: ref.watch(workRepositoryProvider),
    auditRepository: ref.watch(auditRepositoryProvider),
    findingDerivation: const FindingDerivationService(),
    riskEngine: ref.watch(riskEngineProvider),
    auditChain: const AuditChainService(),
    actor: 'local_user',
    useAuditHashChain: true,
  ),
);

final assessmentsProvider = FutureProvider<List<Assessment>>((ref) async {
  final repo = ref.watch(assessmentRepositoryProvider);
  final catalogRepo = ref.watch(catalogRepositoryProvider);
  await catalogRepo.seedIfNeeded();
  return repo.listAssessments();
});
