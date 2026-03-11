enum ChecklistScoringModel {
  conformity,
  maturity,
}

class ChecklistEvidence {
  ChecklistEvidence({
    required this.filePath,
    required this.fileName,
    required this.addedAt,
  });

  final String filePath;
  final String fileName;
  final DateTime addedAt;
}

class ChecklistItem {
  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.riskLevel,
    this.domainId = '',
    this.domainName = '',
    this.domainDescription = '',
    this.scoringModel = ChecklistScoringModel.conformity,
    bool? hasAssessment,
    bool isFulfilled = false,
    int? fulfilmentLevel,
    this.note = '',
    List<String>? criteria,
    Map<int, List<String>>? anchorCriteria,
    List<ChecklistEvidence>? evidence,
  })  : fulfilmentLevel = _normalizeFulfilmentLevel(
          scoringModel: scoringModel,
          value: fulfilmentLevel ?? (isFulfilled ? 2 : 0),
        ),
        hasAssessment =
            hasAssessment ?? ((fulfilmentLevel ?? (isFulfilled ? 2 : 0)) > 0),
        criteria = criteria ?? <String>[],
        anchorCriteria = _normalizeAnchorCriteria(anchorCriteria),
        evidence = evidence ?? <ChecklistEvidence>[];

  final String id;
  final String domainId;
  final String domainName;
  final String domainDescription;
  final String title;
  final String description;
  final int riskLevel;
  final ChecklistScoringModel scoringModel;
  bool hasAssessment;
  int fulfilmentLevel;
  String note;
  final List<String> criteria;
  final Map<int, List<String>> anchorCriteria;
  final List<ChecklistEvidence> evidence;

  bool get usesMaturityScoring =>
      scoringModel == ChecklistScoringModel.maturity;

  bool get isFulfilled =>
      usesMaturityScoring ? fulfilmentLevel >= 5 : fulfilmentLevel == 2;
  bool get isPartiallyFulfilled => usesMaturityScoring
      ? fulfilmentLevel >= 1 && fulfilmentLevel < 5
      : fulfilmentLevel == 1;
  bool get isNotFulfilled => fulfilmentLevel == 0;

  set isFulfilled(bool value) {
    fulfilmentLevel = value ? (usesMaturityScoring ? 5 : 2) : 0;
    hasAssessment = true;
  }

  void applyFulfilmentLevel(int value) {
    fulfilmentLevel = normalizeFulfilmentLevel(value);
    hasAssessment = true;
  }

  String get fulfilmentLabel {
    if (usesMaturityScoring) {
      switch (fulfilmentLevel.clamp(0, 5)) {
        case 0:
          return '0 – nicht vorhanden';
        case 1:
          return '1 – initial / ad-hoc';
        case 2:
          return '2 – wiederholbar';
        case 3:
          return '3 – definiert';
        case 4:
          return '4 – gemanagt';
        default:
          return '5 – optimiert';
      }
    }
    switch (fulfilmentLevel) {
      case 2:
        return 'Komplett erfüllt';
      case 1:
        return 'Teilweise erfüllt';
      default:
        return 'Nicht erfüllt';
    }
  }

  String anchorLabelForLevel(int level) {
    final normalized = normalizeFulfilmentLevel(level);
    if (usesMaturityScoring) {
      switch (normalized) {
        case 0:
          return '0 – nicht vorhanden';
        case 1:
          return '1 – initial / ad-hoc';
        case 2:
          return '2 – wiederholbar';
        case 3:
          return '3 – definiert';
        case 4:
          return '4 – gemanagt';
        default:
          return '5 – optimiert';
      }
    }
    switch (normalized) {
      case 0:
        return 'Nicht erfüllt';
      case 1:
        return 'Teilweise erfüllt';
      default:
        return 'Erfüllt';
    }
  }

  List<String> criteriaForLevel(int level) {
    final normalized = normalizeFulfilmentLevel(level);
    final specific = anchorCriteria[normalized];
    if (specific == null || specific.isEmpty) {
      return criteria;
    }
    return specific;
  }

  List<String> get activeAnchorCriteria => criteriaForLevel(fulfilmentLevel);

  int normalizeFulfilmentLevel(int value) {
    return _normalizeFulfilmentLevel(scoringModel: scoringModel, value: value);
  }

  static int _normalizeFulfilmentLevel({
    required ChecklistScoringModel scoringModel,
    required int value,
  }) {
    if (scoringModel == ChecklistScoringModel.maturity) {
      return value.clamp(0, 5);
    }
    return value.clamp(0, 2);
  }

  static Map<int, List<String>> _normalizeAnchorCriteria(
    Map<int, List<String>>? input,
  ) {
    if (input == null || input.isEmpty) {
      return <int, List<String>>{};
    }
    return <int, List<String>>{
      for (final entry in input.entries)
        entry.key: List<String>.from(entry.value),
    };
  }
}
