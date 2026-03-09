import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/control_risk_service.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenChecklist,
    required this.onOpenRiskAnalysis,
    required this.onBackToProfile,
    required this.items,
    this.onCompleteAssessment,
    this.assessmentName,
  });

  final VoidCallback onOpenChecklist;
  final VoidCallback onOpenRiskAnalysis;
  final Future<String> Function()? onCompleteAssessment;
  final VoidCallback onBackToProfile;
  final List<ChecklistItem> items;
  final String? assessmentName;

  Future<void> _onCompletePressed(BuildContext context) async {
    final complete = onCompleteAssessment;
    if (complete == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prüfung abschließen'),
        content: const Text(
          'Bist du sicher, dass du die aktive Prüfung abschließen und einen PDF-Prüfbericht erzeugen möchtest?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ja, abschließen'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('PDF wird erstellt...'),
            ],
          ),
        ),
      ),
    );

    String reportPath;
    try {
      reportPath = await complete();
    } catch (error) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF-Export fehlgeschlagen: $error'),
          ),
        );
      }
      return;
    }

    if (!context.mounted) {
      return;
    }
    Navigator.of(context, rootNavigator: true).pop();

    final file = File(reportPath);
    if (file.existsSync()) {
      final bytes = await file.readAsBytes();
      await Printing.sharePdf(
        bytes: bytes,
        filename: p.basename(reportPath),
      );
    }

    if (!context.mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prüfbericht erstellt'),
        content: Text(
          'Der Bericht wurde erzeugt:\n$reportPath',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = items.length;
    final done = items.where((e) => e.isFulfilled).length;
    final open = total - done;
    const riskService = ControlRiskService();
    final riskResults =
        items.map(riskService.evaluateControl).toList(growable: false);
    final avgRiskIndex = riskResults.isEmpty
        ? 0.0
        : riskResults.map((r) => r.riskIndex).reduce((a, b) => a + b) /
            riskResults.length;
    final roundedAvgRiskIndex = (avgRiskIndex * 100).roundToDouble() / 100;
    final riskLabel = riskService.riskClassFromScore(roundedAvgRiskIndex);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: onBackToProfile,
        ),
        title: const Text('Rechenzentrum Checkliste'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (assessmentName != null) ...[
                  Text(
                    'Aktive Prüfung:',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    assessmentName!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                FilledButton.icon(
                  onPressed: onOpenChecklist,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.checklist),
                  label: const Text('Checkliste öffnen'),
                ),
                const SizedBox(height: 10),
                _PreviewCard(
                  title: 'Checkliste',
                  lines: [
                    'Erledigt: $done von $total Punkten',
                    'Offen: $open Punkte',
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onOpenRiskAnalysis,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('Kritikalitätsanalyse öffnen'),
                ),
                const SizedBox(height: 10),
                _PreviewCard(
                  title: 'Kritikalitäts-Stand',
                  lines: [
                    'Durchschnittlicher RiskIndex: ${roundedAvgRiskIndex.toStringAsFixed(2)}',
                    'Einstufung: $riskLabel',
                  ],
                ),
                if (assessmentName != null && onCompleteAssessment != null) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _onCompletePressed(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.assignment_turned_in),
                    label: const Text('Prüfung abschließen'),
                  ),
                  const SizedBox(height: 12),
                  const _PreviewCard(
                    title: 'Prüfung abschließen',
                    lines: [
                      'Beim Abschluss wird automatisch ein PDF-Abschlussbericht erzeugt.',
                      'Der Bericht kann danach heruntergeladen oder geteilt werden.',
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD4D4D8)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(line),
            ),
        ],
      ),
    );
  }
}
