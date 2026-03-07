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
    this.isMandatory = true,
    bool isFulfilled = false,
    int? fulfilmentLevel,
    this.note = '',
    List<String>? criteria,
    List<ChecklistEvidence>? evidence,
  })  : fulfilmentLevel =
            (fulfilmentLevel ?? (isFulfilled ? 2 : 0)).clamp(0, 2),
        criteria = criteria ?? <String>[],
        evidence = evidence ?? <ChecklistEvidence>[];

  final String id;
  final String domainId;
  final String domainName;
  final String domainDescription;
  final String title;
  final String description;
  final int riskLevel;
  bool isMandatory;
  int fulfilmentLevel;
  String note;
  final List<String> criteria;
  final List<ChecklistEvidence> evidence;

  bool get isFulfilled => fulfilmentLevel == 2;
  bool get isPartiallyFulfilled => fulfilmentLevel == 1;
  bool get isNotFulfilled => fulfilmentLevel == 0;

  set isFulfilled(bool value) {
    fulfilmentLevel = value ? 2 : 0;
  }

  String get fulfilmentLabel {
    switch (fulfilmentLevel) {
      case 2:
        return 'Komplett erfüllt';
      case 1:
        return 'Teilweise erfüllt';
      default:
        return 'Nicht erfüllt';
    }
  }
}
