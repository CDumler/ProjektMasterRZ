import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';
import 'package:rz_checkliste_risikoanalyse/widgets/checklist_tile.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({
    super.key,
    required this.items,
    required this.onItemChanged,
  });

  final List<ChecklistItem> items;
  final void Function(String itemId, bool fulfilled) onItemChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkliste')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ChecklistTile(
            item: item,
            onChanged: (value) => onItemChanged(item.id, value ?? false),
          );
        },
      ),
    );
  }
}
