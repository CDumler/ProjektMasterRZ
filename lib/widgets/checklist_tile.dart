import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';
import 'package:rz_checkliste_risikoanalyse/widgets/risk_badge.dart';

class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    super.key,
    required this.item,
    required this.onChanged,
  });

  final ChecklistItem item;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Checkbox(value: item.isFulfilled, onChanged: onChanged),
              ],
            ),
            const SizedBox(height: 4),
            Text(item.description),
            const SizedBox(height: 10),
            RiskBadge(riskLevel: item.riskLevel),
          ],
        ),
      ),
    );
  }
}
