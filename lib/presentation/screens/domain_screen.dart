import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class DomainScreen extends ConsumerStatefulWidget {
  const DomainScreen({super.key, required this.assessmentId, required this.domainId});

  final String assessmentId;
  final String domainId;

  @override
  ConsumerState<DomainScreen> createState() => _DomainScreenState();
}

class _DomainScreenState extends ConsumerState<DomainScreen> {
  bool showUnanswered = false;
  bool showCritical = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DomainVm>(
      future: _loadVm(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final vm = snapshot.data!;
        final answerMap = {for (final a in vm.answers) a.controlItemId: a};
        final findingMap = <String, Finding>{for (final f in vm.findings) f.controlItemId: f};

        var items = vm.items;
        if (showUnanswered) {
          items = items.where((i) => !answerMap.containsKey(i.id)).toList(growable: false);
        }
        if (showCritical) {
          items = items
              .where((i) => findingMap[i.id]?.severity == Severity.critical)
              .toList(growable: false);
        }

        return Scaffold(
          appBar: AppBar(title: Text(vm.domain.name)),
          body: Column(
            children: [
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Unbearbeitet'),
                    selected: showUnanswered,
                    onSelected: (v) => setState(() => showUnanswered = v),
                  ),
                  FilterChip(
                    label: const Text('Kritisch'),
                    selected: showCritical,
                    onSelected: (v) => setState(() => showCritical = v),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final answer = answerMap[item.id];
                    final finding = findingMap[item.id];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(
                        answer == null
                            ? 'Noch nicht bewertet'
                            : answer.scoreType == ScoringModel.fulfilment
                                ? 'Bewertung: ${answer.fulfilmentEnum?.name ?? '-'}'
                                : 'Reifegrad: ${answer.maturityLevel ?? '-'}',
                      ),
                      trailing: finding == null
                          ? const Icon(Icons.chevron_right)
                          : Chip(label: Text(finding.severity.name)),
                      onTap: () =>
                          context.push('/assessment/${widget.assessmentId}/item/${item.id}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_DomainVm> _loadVm() async {
    final catalogRepo = ref.read(catalogRepositoryProvider);
    final workRepo = ref.read(workRepositoryProvider);
    final domain = (await catalogRepo.listDomains()).firstWhere((d) => d.id == widget.domainId);
    final items = await catalogRepo.listItemsByDomain(widget.domainId);
    final answers = await workRepo.listAnswers(widget.assessmentId, domainId: widget.domainId);
    final findings = await workRepo.listFindings(widget.assessmentId);
    return _DomainVm(domain: domain, items: items, answers: answers, findings: findings);
  }
}

class _DomainVm {
  const _DomainVm({
    required this.domain,
    required this.items,
    required this.answers,
    required this.findings,
  });

  final DomainEntity domain;
  final List<ControlItem> items;
  final List<ItemAnswer> answers;
  final List<Finding> findings;
}
