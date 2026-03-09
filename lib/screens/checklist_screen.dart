import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/data/control_reference_mapping.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';
import 'package:rz_checkliste_risikoanalyse/widgets/checklist_tile.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({
    super.key,
    required this.items,
    required this.onItemChanged,
    required this.onEvidenceAdded,
    required this.onNoteChanged,
  });

  final List<ChecklistItem> items;
  final void Function(String itemId, int fulfilmentLevel) onItemChanged;
  final void Function(String itemId, ChecklistEvidence evidence)
      onEvidenceAdded;
  final void Function(String itemId, String note) onNoteChanged;

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final Map<String, bool> _expandedByDomain = <String, bool>{};

  Future<void> _uploadEvidenceFor(ChecklistItem item) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'txt'],
    );

    final file =
        (result == null || result.files.isEmpty) ? null : result.files.first;
    if (file == null || file.path == null) {
      return;
    }

    final evidence = ChecklistEvidence(
      filePath: file.path!,
      fileName: file.name,
      addedAt: DateTime.now(),
    );
    widget.onEvidenceAdded(item.id, evidence);
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _onFulfilmentChanged(
    ChecklistItem item,
    int fulfilmentLevel,
  ) async {
    final previousLevel = item.fulfilmentLevel;
    widget.onItemChanged(item.id, fulfilmentLevel);

    if (item.usesMaturityScoring) {
      setState(() {});
      return;
    }

    if (fulfilmentLevel != 2 || previousLevel == 2) {
      setState(() {});
      return;
    }

    final shouldUpload = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Evidenz hinzufügen'),
        content: const Text(
          'Möchtest du jetzt eine Evidenz als Nachweis für diesen Checklistenpunkt hochladen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Später'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Jetzt hochladen'),
          ),
        ],
      ),
    );

    if (shouldUpload == true) {
      await _uploadEvidenceFor(item);
    }

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  bool _isItemAssessed(ChecklistItem item) {
    return item.fulfilmentLevel > 0 ||
        item.note.trim().isNotEmpty ||
        item.evidence.isNotEmpty;
  }

  int? _statusBucketFor(ChecklistItem item) {
    if (!_isItemAssessed(item)) {
      return null;
    }
    if (item.usesMaturityScoring) {
      if (item.fulfilmentLevel >= 4) {
        return 2;
      }
      if (item.fulfilmentLevel >= 2) {
        return 1;
      }
      return 0;
    }
    switch (item.fulfilmentLevel) {
      case 2:
        return 2;
      case 1:
        return 1;
      default:
        return 0;
    }
  }

  _AssessmentCompletion _buildCompletion(List<ChecklistItem> items) {
    final total = items.length;
    final assessed = items.where(_isItemAssessed).length;
    final coverage = total == 0 ? 0.0 : assessed / total;
    final openControls = items.where((item) => !_isItemAssessed(item)).length;

    return _AssessmentCompletion(
      total: total,
      assessed: assessed,
      coverage: coverage,
      openControls: openControls,
    );
  }

  Future<bool> _showAssessmentStatusDialog({
    required bool confirmExit,
  }) async {
    final summary = _buildCompletion(widget.items);

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coverage: ${summary.coveragePercent}%'),
            const SizedBox(height: 4),
            Text('${summary.assessed} / ${summary.total} bewertet'),
            const SizedBox(height: 14),
            const Text(
              'Offene Controls:',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              summary.openControls == 0
                  ? '✔ vollständig bewertet'
                  : '${summary.openControls} noch offen',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(confirmExit ? 'Zurück zur Checkliste' : 'Schließen'),
          ),
          if (confirmExit)
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Checkliste verlassen'),
            ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  Future<void> _onBackPressed() async {
    final shouldExit = await _showAssessmentStatusDialog(confirmExit: true);
    if (!mounted || !shouldExit) {
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _showControlMapping(ChecklistItem item) async {
    final references = controlReferenceMapping[item.id] ?? const <String>[];

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Control Mapping ${item.id}'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (item.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Beschreibung',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(item.description),
                ],
                const SizedBox(height: 12),
                const Text(
                  'Referenzen',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                if (references.isEmpty)
                  const Text('Keine Referenzen für dieses Control hinterlegt.')
                else
                  ...references.map(
                    (reference) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('• $reference'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupItemsByDomain(widget.items);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F8),
        appBar: AppBar(
          title: const Text('Checkliste'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed,
          ),
          actions: [
            IconButton(
              tooltip: 'Assessment Status',
              onPressed: () => _showAssessmentStatusDialog(confirmExit: false),
              icon: const Icon(Icons.assignment_turned_in_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (groups.isEmpty)
              const Card(
                child: ListTile(
                  title: Text('Keine Checklistenpunkte vorhanden.'),
                ),
              )
            else
              ...groups.map(_buildDomainGroupCard),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainGroupCard(_DomainGroup group) {
    final style = _styleForDomain(group.domainId);
    final domainKey = group.domainId.isEmpty ? '__no_domain__' : group.domainId;
    final expanded = _expandedByDomain[domainKey] ?? true;
    final total = group.items.length;
    final fulfilled =
        group.items.where((item) => _statusBucketFor(item) == 2).length;
    final partial =
        group.items.where((item) => _statusBucketFor(item) == 1).length;
    final notFulfilled =
        group.items.where((item) => _statusBucketFor(item) == 0).length;
    final notAssessed =
        group.items.where((item) => !_isItemAssessed(item)).length;
    final assessed = total - notAssessed;
    final coverage = total == 0 ? 0.0 : assessed / total;
    final coveragePercent = (coverage * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: style.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: style.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          onExpansionChanged: (value) {
            setState(() {
              _expandedByDomain[domainKey] = value;
            });
          },
          tilePadding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SizedBox(
              width: 24,
              height: 24,
              child: AnimatedRotation(
                turns: expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(Icons.expand_more, color: style.accent),
              ),
            ),
          ),
          title: Text(
            group.headerTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.domainDescription.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    group.domainDescription,
                    textAlign: TextAlign.justify,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                '$assessed / $total bewertet',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text('Coverage: $coveragePercent %'),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: coverage,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE5E7EB),
                  color: style.accent,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _DomainStatChip(
                    label: 'Kontrollen',
                    value: '$total',
                    color: style.accent,
                  ),
                  _DomainStatChip(
                    label: 'Nicht bewertet',
                    value: '$notAssessed',
                    color: const Color(0xFF6B7280),
                  ),
                  _DomainStatChip(
                    label: 'Nicht erfüllt',
                    value: '$notFulfilled',
                    color: const Color(0xFFB91C1C),
                  ),
                  _DomainStatChip(
                    label: 'Teilweise',
                    value: '$partial',
                    color: const Color(0xFFC2410C),
                  ),
                  _DomainStatChip(
                    label: 'Erfüllt',
                    value: '$fulfilled',
                    color: const Color(0xFF15803D),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Controls dieser Domäne',
                  style: TextStyle(
                    color: style.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            for (final item in group.items)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Stack(
                  children: [
                    ChecklistTile(
                      item: item,
                      onFulfilmentChanged: (level) =>
                          _onFulfilmentChanged(item, level),
                      onAddEvidence: () => _uploadEvidenceFor(item),
                      onNoteChanged: (value) =>
                          widget.onNoteChanged(item.id, value),
                      domainAccentColor: style.accent,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Tooltip(
                        message: 'Control Mapping anzeigen',
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: style.border.withValues(alpha: 0.95),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: IconButton(
                              onPressed: () => _showControlMapping(item),
                              iconSize: 16,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.info_outline_rounded,
                                color: style.accent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<_DomainGroup> _groupItemsByDomain(List<ChecklistItem> items) {
    final grouped = <String, List<ChecklistItem>>{};
    final domainMeta = <String, ChecklistItem>{};

    for (final item in items) {
      final key = item.domainId.isEmpty ? '__no_domain__' : item.domainId;
      grouped.putIfAbsent(key, () => <ChecklistItem>[]).add(item);
      domainMeta.putIfAbsent(key, () => item);
    }

    return grouped.entries.map((entry) {
      final meta = domainMeta[entry.key]!;
      final domainId = meta.domainId;
      final domainName =
          meta.domainName.isEmpty ? 'Ohne Domäne' : meta.domainName;
      final description = meta.domainDescription;
      return _DomainGroup(
        domainId: domainId,
        domainName: domainName,
        domainDescription: description,
        items: entry.value,
      );
    }).toList(growable: false);
  }

  _DomainStyle _styleForDomain(String domainId) {
    switch (domainId) {
      case 'A':
        return const _DomainStyle(
          accent: Color(0xFF0E7490),
          border: Color(0xFF93C5D8),
          surface: Color(0xFFF5FAFC),
          icon: Icons.power_rounded,
        );
      case 'B':
        return const _DomainStyle(
          accent: Color(0xFFB45309),
          border: Color(0xFFF3C08E),
          surface: Color(0xFFFFFAF5),
          icon: Icons.security_rounded,
        );
      case 'C':
        return const _DomainStyle(
          accent: Color(0xFF0F766E),
          border: Color(0xFF8AD0C8),
          surface: Color(0xFFF4FCFA),
          icon: Icons.analytics_outlined,
        );
      case 'D':
        return const _DomainStyle(
          accent: Color(0xFF1D4ED8),
          border: Color(0xFFA9BCF5),
          surface: Color(0xFFF5F8FF),
          icon: Icons.device_hub_rounded,
        );
      case 'E':
        return const _DomainStyle(
          accent: Color(0xFF9F1239),
          border: Color(0xFFF3ADC0),
          surface: Color(0xFFFFF7FA),
          icon: Icons.local_fire_department_rounded,
        );
      default:
        return const _DomainStyle(
          accent: Color(0xFF475569),
          border: Color(0xFFCBD5E1),
          surface: Color(0xFFF8FAFC),
          icon: Icons.layers_rounded,
        );
    }
  }
}

class _AssessmentCompletion {
  const _AssessmentCompletion({
    required this.total,
    required this.assessed,
    required this.coverage,
    required this.openControls,
  });

  final int total;
  final int assessed;
  final double coverage;
  final int openControls;

  int get coveragePercent => (coverage * 100).round();
}

class _DomainGroup {
  const _DomainGroup({
    required this.domainId,
    required this.domainName,
    required this.domainDescription,
    required this.items,
  });

  final String domainId;
  final String domainName;
  final String domainDescription;
  final List<ChecklistItem> items;

  String get headerTitle {
    if (domainId.isEmpty) {
      return domainName;
    }
    return 'Domäne $domainId: $domainName';
  }
}

class _DomainStyle {
  const _DomainStyle({
    required this.accent,
    required this.border,
    required this.surface,
    required this.icon,
  });

  final Color accent;
  final Color border;
  final Color surface;
  final IconData icon;
}

class _DomainStatChip extends StatelessWidget {
  const _DomainStatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
