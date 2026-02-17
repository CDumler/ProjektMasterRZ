import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenChecklist,
    required this.onOpenRiskAnalysis,
    required this.onBackToProfile,
    this.assessmentName,
  });

  final VoidCallback onOpenChecklist;
  final VoidCallback onOpenRiskAnalysis;
  final VoidCallback onBackToProfile;
  final String? assessmentName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rechenzentrum Checkliste')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  icon: const Icon(Icons.checklist),
                  label: const Text('Checkliste öffnen'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onOpenRiskAnalysis,
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text('Risikoanalyse öffnen'),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onBackToProfile,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Zum Profil zurück'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
