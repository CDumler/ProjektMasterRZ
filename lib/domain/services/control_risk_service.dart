import 'dart:math' as math;

import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

enum ControlEvaluationMode {
  modeConformity,
  modeMaturity,
}

const Map<int, String> maturityLevelLabels = <int, String>{
  0: 'Initial',
  1: 'Ad-hoc',
  2: 'Repeatable',
  3: 'Defined',
  4: 'Managed',
  5: 'Optimized',
};

String maturityLevelLabel(int score) {
  final clamped = score.clamp(0, 5);
  return maturityLevelLabels[clamped] ?? 'Initial';
}

class ControlRiskResult {
  const ControlRiskResult({
    required this.control,
    required this.mode,
    required this.modeToken,
    required this.assessmentValue,
    required this.effectiveness,
    required this.gap,
    required this.riskIndex,
    required this.riskClass,
    required this.assessed,
  });

  final ChecklistItem control;
  final ControlEvaluationMode mode;
  final String modeToken;
  final double assessmentValue;
  final double effectiveness;
  final double gap;
  final double riskIndex;
  final String riskClass;
  final bool assessed;
}

class ControlRiskService {
  const ControlRiskService();

  ControlRiskResult evaluateControl(ChecklistItem control) {
    final mode = _modeFor(control);
    final assessmentValue = mode == ControlEvaluationMode.modeConformity
        ? _conformityValue(control)
        : _maturityScore(control);

    // Effectiveness is normalized to 0..1 for both scoring models.
    // Conformity: 0/0.5/1, Maturity: level(0..5)/5.
    final effectiveness = mode == ControlEvaluationMode.modeConformity
        ? assessmentValue
        : _roundTo((assessmentValue / 5.0).clamp(0.0, 1.0), 4);

    // Control-as-Risk rationale:
    // Impact proxy = criticality (K), Likelihood proxy = control gap (1 - E).
    // RiskIndex = K * (1 - E) with bounds 0..5.
    final gap = _roundTo((1.0 - effectiveness).clamp(0.0, 1.0), 4);
    final criticality = control.riskLevel.clamp(1, 5).toDouble();
    final riskIndex = _roundTo((criticality * gap).clamp(0.0, 5.0), 2);

    return ControlRiskResult(
      control: control,
      mode: mode,
      modeToken: mode == ControlEvaluationMode.modeConformity
          ? 'MODE_CONFORMITY'
          : 'MODE_MATURITY',
      assessmentValue: assessmentValue,
      effectiveness: effectiveness,
      gap: gap,
      riskIndex: riskIndex,
      riskClass: riskClassFromScore(riskIndex),
      assessed: isAssessed(control),
    );
  }

  String riskClassFromScore(double score) {
    final safeScore = score.clamp(0.0, 5.0);
    if (safeScore < 1.25) {
      return 'Niedrig';
    }
    if (safeScore < 2.50) {
      return 'Mittel';
    }
    if (safeScore < 3.75) {
      return 'Hoch';
    }
    return 'Kritisch';
  }

  bool isAssessed(ChecklistItem control) {
    return control.fulfilmentLevel > 0 ||
        control.note.trim().isNotEmpty ||
        control.evidence.isNotEmpty;
  }

  ControlEvaluationMode _modeFor(ChecklistItem control) {
    return control.usesMaturityScoring
        ? ControlEvaluationMode.modeMaturity
        : ControlEvaluationMode.modeConformity;
  }

  double _conformityValue(ChecklistItem control) {
    switch (control.fulfilmentLevel) {
      case 2:
        return 1.0;
      case 1:
        return 0.5;
      default:
        return 0.0;
    }
  }

  double _maturityScore(ChecklistItem control) {
    return control.fulfilmentLevel.clamp(0, 5).toDouble();
  }

  double _roundTo(double value, int decimals) {
    final factor = math.pow(10, decimals).toDouble();
    return (value * factor).roundToDouble() / factor;
  }
}
