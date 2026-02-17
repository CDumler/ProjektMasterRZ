import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rz_checkliste_risikoanalyse/models/assessment_record.dart';

class ExistingAssessmentsScreen extends StatelessWidget {
  const ExistingAssessmentsScreen({
    super.key,
    required this.assessments,
    required this.onOpenAssessment,
  });

  final List<AssessmentRecord> assessments;
  final void Function(AssessmentRecord assessment) onOpenAssessment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bestehende Prüfungen')),
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
                final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(assessment.createdAt);
                return Card(
                  child: ListTile(
                    title: Text(assessment.name),
                    subtitle: Text('Erstellt: $formattedDate • Punkte: ${assessment.items.length}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onOpenAssessment(assessment),
                  ),
                );
              },
            ),
    );
  }
}
