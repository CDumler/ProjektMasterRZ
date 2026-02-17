import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class AssessmentRecord {
  AssessmentRecord({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  final String id;
  final String name;
  final List<ChecklistItem> items;
  final DateTime createdAt;
}
