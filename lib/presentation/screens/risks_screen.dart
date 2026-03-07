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
            return Scaffold(
              body: Center(child: Text('Fehler: ${snapshot.error}')),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final risks = snapshot.data!
          ..sort((a, b) => b.score.compareTo(a.score));

        return Scaffold(
          appBar: AppBar(title: const Text('Kritikalitäten')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Top Kritikalitäten'),
              const SizedBox(height: 8),
              ...risks.take(20).map(
                    (r) => ListTile(
                      title: Text('Score ${r.score} (${r.riskClass.name})'),
                      subtitle: Text(
                        'L=${r.likelihood}, I=${r.impact} • ${r.rationale}',
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
