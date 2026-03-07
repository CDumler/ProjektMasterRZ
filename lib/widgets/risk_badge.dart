import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/utils/risk_utils.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.riskLevel});

  final int riskLevel;

  @override
  Widget build(BuildContext context) {
    final color = riskColor(riskLevel);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        'Kritikalität $riskLevel (${riskLabel(riskLevel)})',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
