import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';

class FindingDerivationService {
  const FindingDerivationService({this.maturityThreshold = 3});

  final int maturityThreshold;

  bool shouldCreateFinding(ControlItem item, ItemAnswer answer) {
    if (!item.riskRelevant) {
      return false;
    }
    if (answer.scoreType == ScoringModel.fulfilment) {
      return answer.fulfilmentEnum == Fulfilment.partial ||
          answer.fulfilmentEnum == Fulfilment.notFulfilled;
    }
    return (answer.maturityLevel ?? 0) < maturityThreshold;
  }

  FindingType deriveType(ItemAnswer answer, {required bool evidenceValid}) {
    if (!evidenceValid) {
      return FindingType.missingEvidence;
    }
    if (answer.scoreType == ScoringModel.maturity) {
      return FindingType.processDeficit;
    }
    if (answer.fulfilmentEnum == Fulfilment.notFulfilled) {
      return FindingType.insufficientControl;
    }
    return FindingType.documentationGap;
  }

  Severity deriveSeverity(ItemAnswer answer) {
    if (answer.scoreType == ScoringModel.maturity) {
      final level = answer.maturityLevel ?? 0;
      if (level <= 1) {
        return Severity.critical;
      }
      if (level == 2) {
        return Severity.high;
      }
      return Severity.medium;
    }
    switch (answer.fulfilmentEnum) {
      case Fulfilment.notFulfilled:
        return Severity.high;
      case Fulfilment.partial:
        return Severity.medium;
      case Fulfilment.fulfilled:
      case null:
        return Severity.low;
    }
  }
}
