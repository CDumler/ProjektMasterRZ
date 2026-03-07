import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class AssessmentSetupScreen extends StatefulWidget {
  const AssessmentSetupScreen({
    super.key,
    required this.initialItems,
    required this.onStartWithChecklist,
  });

  final List<ChecklistItem> initialItems;
  final void Function(String assessmentName, List<ChecklistItem> items)
      onStartWithChecklist;

  @override
  State<AssessmentSetupScreen> createState() => _AssessmentSetupScreenState();
}

class _AssessmentSetupScreenState extends State<AssessmentSetupScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final List<ChecklistItem> _activeItems;
  final List<ChecklistItem> _inactiveItems = <ChecklistItem>[];
  final Map<String, bool> _expandedByDomainPanel = <String, bool>{};
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _activeItems = widget.initialItems
        .map(
          (e) => ChecklistItem(
            id: e.id,
            domainId: e.domainId,
            domainName: e.domainName,
            domainDescription: e.domainDescription,
            title: e.title,
            description: e.description,
            riskLevel: e.riskLevel,
            isMandatory: e.isMandatory,
            isFulfilled: false,
            criteria: List<String>.from(e.criteria),
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
      builder: (context) => const _ChecklistItemDialog(
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
    final activeGroups = _groupItemsByDomain(_activeItems);
    final inactiveGroups = _groupItemsByDomain(_inactiveItems);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
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
                  filled: true,
                  fillColor: Colors.white,
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
                  label: Text(
                    _editMode ? 'Bearbeiten beendet' : 'Punkte bearbeiten',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              children: [
                _buildSectionTitle(
                  context,
                  title: 'Aktive Checklistenpunkte',
                  icon: Icons.fact_check_rounded,
                  color: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 8),
                if (activeGroups.isEmpty)
                  const Card(
                    child: ListTile(title: Text('Keine Punkte aktiv')),
                  )
                else
                  ...activeGroups.map(_buildActiveDomainCard),
                const SizedBox(height: 14),
                _buildSectionTitle(
                  context,
                  title: 'Deaktivierte Punkte',
                  icon: Icons.pause_circle_outline_rounded,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(height: 8),
                if (inactiveGroups.isEmpty)
                  const Card(
                    child: ListTile(
                      title: Text('Keine ausgegrauten Punkte'),
                    ),
                  )
                else
                  ...inactiveGroups.map(_buildInactiveDomainCard),
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

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }

  Widget _buildActiveDomainCard(_DomainGroup group) {
    final style = _styleForDomain(group.domainId);
    final mandatoryItems =
        group.items.where((item) => item.isMandatory).toList(growable: false);
    final optionalItems =
        group.items.where((item) => !item.isMandatory).toList(growable: false);

    return _buildDomainPanel(
      panelKey: 'active:${group.domainId}',
      group: group,
      style: style,
      initiallyExpanded: true,
      chips: [
        _DomainStatChip(
          label: 'Controls',
          value: '${group.items.length}',
          color: style.accent,
        ),
        _DomainStatChip(
          label: 'Pflicht',
          value: '${mandatoryItems.length}',
          color: const Color(0xFF991B1B),
        ),
        _DomainStatChip(
          label: 'Optional',
          value: '${optionalItems.length}',
          color: const Color(0xFF166534),
        ),
      ],
      childWidgets: [
        if (mandatoryItems.isNotEmpty) ...[
          _SectionHeader(
            title: 'Pflichtpunkte',
            color: const Color(0xFF991B1B),
            count: mandatoryItems.length,
          ),
          const SizedBox(height: 6),
          ...mandatoryItems
              .map((item) => _buildActiveItemCard(item, style: style)),
        ],
        if (optionalItems.isNotEmpty) ...[
          _SectionHeader(
            title: 'Optionale Punkte',
            color: const Color(0xFF065F46),
            count: optionalItems.length,
          ),
          const SizedBox(height: 6),
          ...optionalItems
              .map((item) => _buildActiveItemCard(item, style: style)),
        ],
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildInactiveDomainCard(_DomainGroup group) {
    final style = _styleForDomain(group.domainId);
    final mandatoryItems =
        group.items.where((item) => item.isMandatory).toList(growable: false);
    final optionalItems =
        group.items.where((item) => !item.isMandatory).toList(growable: false);

    return _buildDomainPanel(
      panelKey: 'inactive:${group.domainId}',
      group: group,
      style: style,
      initiallyExpanded: false,
      chips: [
        _DomainStatChip(
          label: 'Deaktiviert',
          value: '${group.items.length}',
          color: const Color(0xFF64748B),
        ),
      ],
      childWidgets: [
        if (mandatoryItems.isNotEmpty) ...[
          _SectionHeader(
            title: 'Pflichtpunkte',
            color: const Color(0xFF991B1B),
            count: mandatoryItems.length,
          ),
          const SizedBox(height: 6),
          ...mandatoryItems
              .map((item) => _buildInactiveItemCard(item, style: style)),
        ],
        if (optionalItems.isNotEmpty) ...[
          _SectionHeader(
            title: 'Optionale Punkte',
            color: const Color(0xFF065F46),
            count: optionalItems.length,
          ),
          const SizedBox(height: 6),
          ...optionalItems
              .map((item) => _buildInactiveItemCard(item, style: style)),
        ],
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildDomainPanel({
    required String panelKey,
    required _DomainGroup group,
    required _DomainStyle style,
    required bool initiallyExpanded,
    required List<Widget> chips,
    required List<Widget> childWidgets,
  }) {
    final expanded = _expandedByDomainPanel[panelKey] ?? initiallyExpanded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: style.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: style.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
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
              _expandedByDomainPanel[panelKey] = value;
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
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < chips.length; i++) ...[
                      chips[i],
                      if (i < chips.length - 1) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
          children: childWidgets,
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
      return _DomainGroup(
        domainId: meta.domainId,
        domainName: meta.domainName.isEmpty ? 'Ohne Domäne' : meta.domainName,
        domainDescription: meta.domainDescription,
        items: entry.value,
      );
    }).toList(growable: false);
  }

  Widget _buildActiveItemCard(ChecklistItem item,
      {required _DomainStyle style}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: style.border.withValues(alpha: 0.9)),
        ),
        child: ListTile(
          title: Text(item.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item.description,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.id,
                  style: TextStyle(
                    color: style.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          trailing: Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Kritikalität ${item.riskLevel}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
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
    );
  }

  Widget _buildInactiveItemCard(
    ChecklistItem item, {
    required _DomainStyle style,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: ListTile(
          title: Text(
            item.title,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item.description,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.id,
                  style: TextStyle(
                    color: style.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            tooltip: 'Zur Liste hinzufügen',
            onPressed: () => _restoreToChecklist(item),
            icon: const Icon(Icons.add_circle, color: Colors.green),
          ),
        ),
      ),
    );
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.color,
    required this.count,
  });

  final String title;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
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
  late bool _isMandatory;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialItem?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialItem?.description ?? '');
    _riskLevel = widget.initialItem?.riskLevel ?? 3;
    _isMandatory = widget.initialItem?.isMandatory ?? true;
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
      id: widget.initialItem?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      domainId: widget.initialItem?.domainId ?? '',
      domainName: widget.initialItem?.domainName ?? '',
      domainDescription: widget.initialItem?.domainDescription ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      riskLevel: _riskLevel,
      isMandatory: _isMandatory,
      fulfilmentLevel: widget.initialItem?.fulfilmentLevel ?? 0,
      criteria:
          List<String>.from(widget.initialItem?.criteria ?? const <String>[]),
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
                decoration: const InputDecoration(labelText: 'Kritikalität'),
                items: List.generate(
                  5,
                  (i) =>
                      DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                ),
                onChanged: (value) => setState(() => _riskLevel = value ?? 3),
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                value: _isMandatory,
                onChanged: (value) => setState(() => _isMandatory = value),
                title: const Text('Pflichtpunkt'),
                subtitle: Text(
                  _isMandatory
                      ? 'Dieser Punkt muss zwingend geprüft werden.'
                      : 'Dieser Punkt ist optional.',
                ),
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
