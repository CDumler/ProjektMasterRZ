import 'package:flutter/material.dart';

Color riskColor(int risk) {
  if (risk <= 2) {
    return Colors.green;
  }
  if (risk <= 4) {
    return Colors.orange;
  }
  return Colors.red;
}

String riskLabel(int risk) {
  if (risk <= 2) {
    return 'Niedrig';
  }
  if (risk <= 4) {
    return 'Mittel';
  }
  return 'Hoch';
}

double averageRisk(Iterable<int> values) {
  if (values.isEmpty) {
    return 0;
  }
  final sum = values.fold<int>(0, (acc, value) => acc + value);
  return sum / values.length;
}
