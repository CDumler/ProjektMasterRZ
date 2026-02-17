import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';
import 'package:rz_checkliste_risikoanalyse/utils/risk_utils.dart';
import 'package:rz_checkliste_risikoanalyse/widgets/risk_badge.dart';

class RiskAnalysisScreen extends StatelessWidget {
  const RiskAnalysisScreen({super.key, required this.items});

  final List<ChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    final avg = averageRisk(items.map((item) => item.riskLevel));
    final unresolved = items.where((item) => !item.isFulfilled).toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Risikoanalyse')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: riskColor(avg.round()).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Durchschnittliches Risiko', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  avg.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 6),
                Text('Offene Punkte: ${unresolved.length} von ${items.length}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Einzelrisiken', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items.map(
            (item) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              title: Text(item.title),
              subtitle: Text(item.isFulfilled ? 'Status: Erfüllt' : 'Status: Nicht erfüllt'),
              trailing: RiskBadge(riskLevel: item.riskLevel),
            ),
          ),
        ],
      ),
    );
  }
}
