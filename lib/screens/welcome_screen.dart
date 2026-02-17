import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE6FFFC),
              Color(0xFFC9F5EF),
              Color(0xFFB0ECE6),
            ],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFA8E6DE), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 24,
                            color: const Color(0xFF0F766E).withValues(alpha: 0.14),
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _HeroBadge(),
                          const SizedBox(height: 18),
                          Text(
                            'Willkommen zur\nRZ-Checkliste und Risikoanalyse.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF0B4F4A),
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Rechenzentren werden strukturiert bewertet, Risiken quantifiziert und Evidenzen revisionssicher dokumentiert – normreferenziert und auditfähig.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF245F5A),
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              _FeatureChip(icon: Icons.rule_folder, label: 'Normreferenziert'),
                              _FeatureChip(icon: Icons.verified_user, label: 'Auditfähig'),
                              _FeatureChip(icon: Icons.lock_clock, label: 'Revisionssicher'),
                            ],
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: onStart,
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: const Text('Jetzt starten'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF14B8A6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6FFFB),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF9EDFD6)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.security_rounded, size: 18, color: Color(0xFF0E7490)),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Enterprise Data Center Assessment',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF0E7490),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFA8E6DE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF0F766E)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF155E57), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
