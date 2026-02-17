import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class AssessmentSetupScreen extends StatefulWidget {
  const AssessmentSetupScreen({
    super.key,
    required this.initialItems,
    required this.onStartWithChecklist,
  });

  final List<ChecklistItem> initialItems;
  final void Function(String assessmentName, List<ChecklistItem> items) onStartWithChecklist;

  @override
  State<AssessmentSetupScreen> createState() => _AssessmentSetupScreenState();
}

class _AssessmentSetupScreenState extends State<AssessmentSetupScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final List<ChecklistItem> _activeItems;
  final List<ChecklistItem> _inactiveItems = <ChecklistItem>[];
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _activeItems = widget.initialItems
        .map(
          (e) => ChecklistItem(
            id: e.id,
            title: e.title,
            description: e.description,
            riskLevel: e.riskLevel,
            isFulfilled: false,
          ),
        )
        .toList(growable: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addItemDialog() async {
    final created = await showDialog<ChecklistItem>(
      context: context,
      builder: (context) => _ChecklistItemDialog(
        title: 'Neuen Checklistenpunkt hinzufügen',
        submitText: 'Hinzufügen',
      ),
    );

    if (created == null) {
      return;
    }
    setState(() => _activeItems.add(created));
  }

  Future<void> _editItemDialog(ChecklistItem item) async {
    final updated = await showDialog<ChecklistItem>(
      context: context,
      builder: (context) => _ChecklistItemDialog(
        title: 'Checklistenpunkt bearbeiten',
        submitText: 'Speichern',
        initialItem: item,
      ),
    );

    if (updated == null) {
      return;
    }
    setState(() {
      final index = _activeItems.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        _activeItems[index] = updated;
      }
    });
  }

  Future<void> _removeFromChecklist(ChecklistItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Punkt deaktivieren'),
        content: Text(
          'Möchtest du den Punkt "${item.title}" wirklich aus der aktiven Checkliste entfernen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deaktivieren'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _activeItems.removeWhere((e) => e.id == item.id);
      _inactiveItems.add(item);
    });
  }

  void _restoreToChecklist(ChecklistItem item) {
    setState(() {
      _inactiveItems.removeWhere((e) => e.id == item.id);
      _activeItems.add(item);
    });
  }

  void _start() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    widget.onStartWithChecklist(_nameController.text.trim(), _activeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkliste erstellen')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Prüfungsname',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Bitte einen Prüfungsnamen eingeben.';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _addItemDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Punkt hinzufügen'),
                ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _editMode = !_editMode),
                  icon: const Icon(Icons.edit),
                  label: Text(_editMode ? 'Bearbeiten beendet' : 'Punkte bearbeiten'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              children: [
                Text(
                  'Aktive Checklistenpunkte',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ..._activeItems.map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Risiko ${item.riskLevel}'),
                          IconButton(
                            tooltip: 'Aus Liste entfernen',
                            onPressed: () => _removeFromChecklist(item),
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        ],
                      ),
                      onTap: _editMode ? () => _editItemDialog(item) : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Deaktivierte Punkte',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (_inactiveItems.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('Keine ausgegrauten Punkte'),
                    ),
                  )
                else
                  ..._inactiveItems.map(
                    (item) => Card(
                      color: Colors.grey.shade100,
                      child: ListTile(
                        title: Text(
                          item.title,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        subtitle: Text(
                          item.description,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: IconButton(
                          tooltip: 'Zur Liste hinzufügen',
                          onPressed: () => _restoreToChecklist(item),
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _start,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Prüfung mit dieser Checkliste starten'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItemDialog extends StatefulWidget {
  const _ChecklistItemDialog({
    required this.title,
    required this.submitText,
    this.initialItem,
  });

  final String title;
  final String submitText;
  final ChecklistItem? initialItem;

  @override
  State<_ChecklistItemDialog> createState() => _ChecklistItemDialogState();
}

class _ChecklistItemDialogState extends State<_ChecklistItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late int _riskLevel;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialItem?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialItem?.description ?? '');
    _riskLevel = widget.initialItem?.riskLevel ?? 3;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final model = ChecklistItem(
      id: widget.initialItem?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      riskLevel: _riskLevel,
      isFulfilled: widget.initialItem?.isFulfilled ?? false,
    );

    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titel'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Bitte Titel eingeben.'
                    : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Bitte Beschreibung eingeben.'
                    : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _riskLevel,
                decoration: const InputDecoration(labelText: 'Risiko-Level'),
                items: List.generate(
                  5,
                  (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                ),
                onChanged: (value) => setState(() => _riskLevel = value ?? 3),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.submitText),
        ),
      ],
    );
  }
}
