class ChecklistItem {
  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.riskLevel,
    this.isFulfilled = false,
  });

  final String id;
  final String title;
  final String description;
  final int riskLevel;
  bool isFulfilled;
}
