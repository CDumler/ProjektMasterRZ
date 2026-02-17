import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class RisksScreen extends ConsumerWidget {
  const RisksScreen({super.key, required this.assessmentId});

  final String assessmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<RiskRecord>>(
      future: ref.read(workRepositoryProvider).listRisks(assessmentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final risks = snapshot.data!..sort((a, b) => b.score.compareTo(a.score));
        final matrix = List.generate(5, (_) => List<int>.filled(5, 0));
        for (final r in risks) {
          matrix[r.impact - 1][r.likelihood - 1] += 1;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Risiken & Heatmap')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Heatmap (Impact x Likelihood)'),
              const SizedBox(height: 8),
              Table(
                border: TableBorder.all(color: Colors.black12),
                children: [
                  for (int impact = 5; impact >= 1; impact--)
                    TableRow(
                      children: [
                        for (int likelihood = 1; likelihood <= 5; likelihood++)
                          Container(
                            alignment: Alignment.center,
                            height: 36,
                            color: _cellColor(impact * likelihood),
                            child: Text('${matrix[impact - 1][likelihood - 1]}'),
                          ),
                      ],
                    )
                ],
              ),
              const SizedBox(height: 16),
              const Text('Top Risiken'),
              const SizedBox(height: 8),
              ...risks.take(20).map(
                    (r) => ListTile(
                      title: Text('Score ${r.score} (${r.riskClass.name})'),
                      subtitle: Text('L=${r.likelihood}, I=${r.impact} • ${r.rationale}'),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Color _cellColor(int score) {
    if (score <= 5) {
      return Colors.green.shade100;
    }
    if (score <= 10) {
      return Colors.yellow.shade200;
    }
    if (score <= 15) {
      return Colors.orange.shade300;
    }
    return Colors.red.shade300;
  }
}
