import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rz_checkliste_risikoanalyse/models/assessment_record.dart';

class ExistingAssessmentsScreen extends StatefulWidget {
  const ExistingAssessmentsScreen({
    super.key,
    required this.assessments,
    required this.onOpenAssessment,
    required this.onDeleteAssessments,
  });

  final List<AssessmentRecord> assessments;
  final void Function(AssessmentRecord assessment) onOpenAssessment;
  final void Function(List<String> assessmentIds) onDeleteAssessments;

  @override
  State<ExistingAssessmentsScreen> createState() =>
      _ExistingAssessmentsScreenState();
}

class _ExistingAssessmentsScreenState extends State<ExistingAssessmentsScreen> {
  final Set<String> _selectedIds = <String>{};
  bool _selectionMode = false;

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _confirmAndDeleteSelected() async {
    if (_selectedIds.isEmpty) {
      return;
    }

    final count = _selectedIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prüfungen löschen'),
        content: Text(
          'Möchtest du $count ausgewählte Prüfung${count == 1 ? '' : 'en'} wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final ids = _selectedIds.toList(growable: false);
    widget.onDeleteAssessments(ids);
    setState(() {
      _selectedIds.clear();
      _selectionMode = false;
    });

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$count Prüfung${count == 1 ? '' : 'en'} gelöscht.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assessments = widget.assessments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectionMode
              ? '${_selectedIds.length} ausgewählt'
              : 'Bestehende Prüfungen',
        ),
        actions: [
          if (!_selectionMode && assessments.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _selectionMode = true),
              child: const Text('Auswählen'),
            ),
          if (_selectionMode)
            TextButton(
              onPressed: _selectedIds.isEmpty ? null : _confirmAndDeleteSelected,
              child: const Text('Löschen'),
            ),
          if (_selectionMode)
            TextButton(
              onPressed: () => setState(() {
                _selectedIds.clear();
                _selectionMode = false;
              }),
              child: const Text('Abbrechen'),
            ),
        ],
      ),
      body: assessments.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Es gibt noch keine gespeicherten Prüfungen.\nBitte zuerst über "Prüfung starten" eine Prüfung anlegen.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: assessments.length,
              itemBuilder: (context, index) {
                final assessment = assessments[index];
                final formattedDate =
                    DateFormat('dd.MM.yyyy HH:mm').format(assessment.createdAt);
                final selected = _selectedIds.contains(assessment.id);
                return Card(
                  child: ListTile(
                    leading: _selectionMode
                        ? Checkbox(
                            value: selected,
                            onChanged: (_) => _toggleSelection(assessment.id),
                          )
                        : null,
                    title: Text(assessment.name),
                    subtitle: Text(
                        'Erstellt: $formattedDate • Punkte: ${assessment.items.length}'),
                    trailing:
                        _selectionMode ? null : const Icon(Icons.chevron_right),
                    selected: selected,
                    onTap: () {
                      if (_selectionMode) {
                        _toggleSelection(assessment.id);
                        return;
                      }
                      widget.onOpenAssessment(assessment);
                    },
                  ),
                );
              },
            ),
    );
  }
}
