import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class AssessmentRecord {
  AssessmentRecord({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    this.createdBy,
    this.status,
    this.itemCount,
  });

  final String id;
  final String name;
  final List<ChecklistItem> items;
  final DateTime createdAt;
  final String? createdBy;
  final String? status;
  final int? itemCount;
}
