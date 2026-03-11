import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';
import 'package:rz_checkliste_risikoanalyse/widgets/risk_badge.dart';

class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    super.key,
    required this.item,
    required this.onFulfilmentChanged,
    required this.onAddEvidence,
    required this.onNoteChanged,
    this.domainAccentColor,
  });

  final ChecklistItem item;
  final ValueChanged<int> onFulfilmentChanged;
  final VoidCallback onAddEvidence;
  final ValueChanged<String> onNoteChanged;
  final Color? domainAccentColor;

  @override
  Widget build(BuildContext context) {
    final accent = domainAccentColor ?? const Color(0xFF0F766E);
    final statusStyle = _statusStyle(_statusFor(item));
    final isHighCriticality = item.riskLevel >= 4;
    final usesMaturityScoring = item.usesMaturityScoring;
    final visibleCriteria = item.activeAnchorCriteria;
    final activeAnchorLabel = item.anchorLabelForLevel(item.fulfilmentLevel);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: statusStyle.color.withValues(alpha: 0.45),
          width: isHighCriticality ? 1.8 : 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.id,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusStyle.color.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: statusStyle.color.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        statusStyle.label,
                        style: TextStyle(
                          color: statusStyle.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isHighCriticality)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hohe Kritikalität · Stufe ${item.riskLevel}',
                          style: const TextStyle(
                            color: Color(0xFFB91C1C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  RiskBadge(riskLevel: item.riskLevel),
              ],
            ),
            const SizedBox(height: 10),
            InputDecorator(
              decoration: InputDecoration(
                labelText: usesMaturityScoring
                    ? 'Reifegradbewertung'
                    : 'Erfüllungsstatus',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: item.fulfilmentLevel,
                  isExpanded: true,
                  items: usesMaturityScoring
                      ? const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('0 – nicht vorhanden'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('1 – initial / ad-hoc'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('2 – wiederholbar'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('3 – definiert'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('4 – gemanagt'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('5 – optimiert'),
                          ),
                        ]
                      : const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text('Nicht erfüllt'),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Teilweise erfüllt'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Komplett erfüllt'),
                          ),
                        ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    onFulfilmentChanged(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              textAlign: TextAlign.left,
            ),
            if (visibleCriteria.isNotEmpty) ...[
              const SizedBox(height: 10),
              _SectionCard(
                title: 'Kriterien',
                subtitle: 'Bewertungsanker: $activeAnchorLabel',
                child: Column(
                  children: [
                    for (final criterion in visibleCriteria)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(
                                Icons.circle,
                                size: 6,
                                color: Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                criterion,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            _SectionCard(
              title: 'Evidence',
              subtitle: 'Dateien, Bilder, Dokumente',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: (item.usesMaturityScoring
                            ? item.hasAssessment && item.fulfilmentLevel > 0
                            : item.fulfilmentLevel == 2)
                        ? onAddEvidence
                        : null,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Evidenz hochladen'),
                  ),
                  if (item.evidence.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text('Noch keine Evidenz hinterlegt.'),
                    )
                  else
                    ...item.evidence.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.description, size: 16),
                            const SizedBox(width: 6),
                            Expanded(child: Text(e.fileName)),
                            Text(
                              '${e.addedAt.day.toString().padLeft(2, '0')}.${e.addedAt.month.toString().padLeft(2, '0')}.${e.addedAt.year}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _SectionCard(
              title: 'Comment',
              subtitle: 'Begründung der Bewertung',
              child: TextFormField(
                initialValue: item.note,
                minLines: 2,
                maxLines: 4,
                onChanged: onNoteChanged,
                decoration: const InputDecoration(
                  labelText: 'Kommentar',
                  hintText: 'Bewertung kurz begründen (optional).',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAssessed(ChecklistItem control) {
    return control.hasAssessment ||
        control.note.trim().isNotEmpty ||
        control.evidence.isNotEmpty;
  }

  _ControlUiStatus _statusFor(ChecklistItem control) {
    if (!_isAssessed(control)) {
      return _ControlUiStatus.notAssessed;
    }
    if (control.usesMaturityScoring) {
      if (control.fulfilmentLevel >= 4) {
        return _ControlUiStatus.fulfilled;
      }
      if (control.fulfilmentLevel >= 2) {
        return _ControlUiStatus.partial;
      }
      return _ControlUiStatus.notFulfilled;
    }
    switch (control.fulfilmentLevel) {
      case 2:
        return _ControlUiStatus.fulfilled;
      case 1:
        return _ControlUiStatus.partial;
      default:
        return _ControlUiStatus.notFulfilled;
    }
  }

  _ControlStatusStyle _statusStyle(_ControlUiStatus status) {
    switch (status) {
      case _ControlUiStatus.notAssessed:
        return const _ControlStatusStyle(
          label: 'Nicht bewertet',
          color: Color(0xFF6B7280),
        );
      case _ControlUiStatus.notFulfilled:
        return const _ControlStatusStyle(
          label: 'Nicht erfüllt',
          color: Color(0xFFB91C1C),
        );
      case _ControlUiStatus.partial:
        return const _ControlStatusStyle(
          label: 'Teilweise erfüllt',
          color: Color(0xFFC2410C),
        );
      case _ControlUiStatus.fulfilled:
        return const _ControlStatusStyle(
          label: 'Erfüllt',
          color: Color(0xFF15803D),
        );
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

enum _ControlUiStatus {
  notAssessed,
  notFulfilled,
  partial,
  fulfilled,
}

class _ControlStatusStyle {
  const _ControlStatusStyle({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;
}
