import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rz_checkliste_risikoanalyse/core/id.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  const ItemDetailScreen({super.key, required this.assessmentId, required this.itemId});

  final String assessmentId;
  final String itemId;

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  Fulfilment fulfilment = Fulfilment.partial;
  int maturity = 2;
  int likelihood = 3;
  int impact = 3;
  final notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ItemVm>(
      future: _loadVm(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final vm = snapshot.data!;
        final item = vm.item;

        return Scaffold(
          appBar: AppBar(title: Text(item.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(item.objective, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(item.question),
              const SizedBox(height: 12),
              Text('Normreferenzen', style: Theme.of(context).textTheme.titleSmall),
              ...vm.normRefs.map((n) => Text('${n.standardName} ${n.standardVersion} ${n.refCode}')),
              const SizedBox(height: 12),
              Text('Ankertexte: ${item.anchorsJson}'),
              const SizedBox(height: 12),
              if (item.scoringModel == ScoringModel.fulfilment)
                DropdownButtonFormField<Fulfilment>(
                  value: fulfilment,
                  decoration: const InputDecoration(labelText: 'Erfüllungsgrad'),
                  items: Fulfilment.values
                      .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                      .toList(growable: false),
                  onChanged: (v) => setState(() => fulfilment = v ?? Fulfilment.partial),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reifegrad: $maturity'),
                    Slider(
                      value: maturity.toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: '$maturity',
                      onChanged: (v) => setState(() => maturity = v.round()),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              TextField(controller: notes, decoration: const InputDecoration(labelText: 'Kommentar/Feststellung')),
              const SizedBox(height: 8),
              Text('Likelihood: $likelihood'),
              Slider(
                value: likelihood.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (v) => setState(() => likelihood = v.round()),
              ),
              Text('Impact: $impact'),
              Slider(
                value: impact.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (v) => setState(() => impact = v.round()),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () async {
                      final orchestrator = ref.read(orchestratorProvider);
                      await orchestrator.answerItem(
                        assessment: vm.assessment,
                        item: item,
                        scoreType: item.scoringModel,
                        fulfilment: item.scoringModel == ScoringModel.fulfilment ? fulfilment : null,
                        maturityLevel: item.scoringModel == ScoringModel.maturity ? maturity : null,
                        notes: notes.text,
                        answeredBy: 'local_user',
                        likelihood: likelihood,
                        impact: impact,
                      );
                      if (!mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bewertung gespeichert.')),
                      );
                    },
                    child: const Text('Bewertung speichern'),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await ref.read(evidenceServiceProvider).pickAndStore(widget.assessmentId);
                      if (picked == null) {
                        return;
                      }
                      final evidence = Evidence(
                        id: newId('evd'),
                        assessmentId: widget.assessmentId,
                        linkedEntityType: EntityType.itemAnswer,
                        linkedEntityId: widget.itemId,
                        filePath: picked.filePath,
                        fileName: picked.fileName,
                        mimeType: picked.mimeType,
                        fileHash: picked.hash,
                        hashAlg: picked.hashAlg,
                        source: 'lokaler Upload',
                        owner: 'local_user',
                        confidentiality: 'internal',
                        status: EvidenceStatus.valid,
                        notes: '',
                        createdAt: DateTime.now(),
                      );
                      await ref.read(orchestratorProvider).addEvidence(evidence);
                      if (!mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Evidenz hinzugefügt.')));
                    },
                    child: const Text('Evidenz hinzufügen'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_ItemVm> _loadVm() async {
    final catalogRepo = ref.read(catalogRepositoryProvider);
    final assessmentRepo = ref.read(assessmentRepositoryProvider);
    final allItems = await catalogRepo.listAllItems();
    final item = allItems.firstWhere((i) => i.id == widget.itemId);
    final assessment = await assessmentRepo.getAssessment(widget.assessmentId);
    if (assessment == null) {
      throw StateError('Assessment nicht gefunden');
    }
    final refs = await catalogRepo.listNormReferencesForItem(widget.itemId);
    return _ItemVm(item: item, assessment: assessment, normRefs: refs);
  }
}

class _ItemVm {
  const _ItemVm({required this.item, required this.assessment, required this.normRefs});

  final ControlItem item;
  final Assessment assessment;
  final List<NormReference> normRefs;
}
