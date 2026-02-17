import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class AssessmentDetailScreen extends ConsumerWidget {
  const AssessmentDetailScreen({super.key, required this.assessmentId});

  final String assessmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<_AssessmentDetailVm>(
      future: _loadVm(ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final vm = snapshot.data!;
        final answered = vm.answers.map((a) => a.controlItemId).toSet().length;
        final progress = vm.items.isEmpty ? 0.0 : answered / vm.items.length;

        return Scaffold(
          appBar: AppBar(title: Text(vm.assessment.name)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${vm.assessment.org} • ${vm.assessment.location}'),
                      Text('Status: ${vm.assessment.status.name}'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 8),
                      Text('Fortschritt: ${(progress * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => context.push('/assessment/$assessmentId/findings'),
                    child: Text('Findings (${vm.findings.where((f) => f.status == FindingStatus.open).length})'),
                  ),
                  FilledButton(
                    onPressed: () => context.push('/assessment/$assessmentId/risks'),
                    child: Text('Risiken (${vm.risks.length})'),
                  ),
                  FilledButton(
                    onPressed: () => context.push('/assessment/$assessmentId/evidence'),
                    child: Text('Evidenzen (${vm.evidence.length})'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.push('/assessment/$assessmentId/audit'),
                    child: const Text('Audit-Trail'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Domänen'),
                      subtitle: const Text('Technik, Physisch, Betrieb, Netzwerk, Notfall'),
                      trailing: PopupMenuButton<AssessmentStatus>(
                        onSelected: (status) async {
                          await ref.read(orchestratorProvider).updateAssessmentStatus(assessmentId, status);
                          ref.invalidate(assessmentsProvider);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Status auf ${status.name} gesetzt')));
                        },
                        itemBuilder: (_) => AssessmentStatus.values
                            .map((s) => PopupMenuItem(value: s, child: Text(s.name)))
                            .toList(growable: false),
                      ),
                    ),
                    for (final domain in vm.domains)
                      ListTile(
                        title: Text(domain.name),
                        subtitle: Text(domain.description),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/assessment/$assessmentId/domain/${domain.id}'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () async {
                  final exportService = ref.read(exportServiceProvider);
                  final artifacts = await exportService.exportAll(
                    assessment: vm.assessment,
                    answers: vm.answers,
                    findings: vm.findings,
                    risks: vm.risks,
                    evidence: vm.evidence,
                  );
                  await ref.read(orchestratorProvider).auditExport(
                        entityType: EntityType.assessment,
                        entityId: assessmentId,
                        payload: {
                          'json': artifacts.jsonPath,
                          'pdf': artifacts.pdfPath,
                          'zip': artifacts.evidenceZipPath,
                        },
                      );
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export erstellt: ${artifacts.pdfPath}')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Report + Exporte erzeugen'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_AssessmentDetailVm> _loadVm(WidgetRef ref) async {
    final assessmentRepo = ref.read(assessmentRepositoryProvider);
    final catalogRepo = ref.read(catalogRepositoryProvider);
    final workRepo = ref.read(workRepositoryProvider);

    final asm = await assessmentRepo.getAssessment(assessmentId);
    if (asm == null) {
      throw StateError('Assessment nicht gefunden');
    }

    final domains = await catalogRepo.listDomains();
    final items = await catalogRepo.listAllItems();
    final answers = await workRepo.listAnswers(assessmentId);
    final findings = await workRepo.listFindings(assessmentId);
    final risks = await workRepo.listRisks(assessmentId);
    final evidence = await workRepo.listEvidence(assessmentId);

    return _AssessmentDetailVm(
      assessment: asm,
      domains: domains,
      items: items,
      answers: answers,
      findings: findings,
      risks: risks,
      evidence: evidence,
    );
  }
}

class _AssessmentDetailVm {
  const _AssessmentDetailVm({
    required this.assessment,
    required this.domains,
    required this.items,
    required this.answers,
    required this.findings,
    required this.risks,
    required this.evidence,
  });

  final Assessment assessment;
  final List<DomainEntity> domains;
  final List<ControlItem> items;
  final List<ItemAnswer> answers;
  final List<Finding> findings;
  final List<RiskRecord> risks;
  final List<Evidence> evidence;
}
