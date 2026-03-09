import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

const Map<String, List<String>> _controlReferenceMapping =
    <String, List<String>>{
  'A-CTRL-01': <String>[
    'EN 50600-2-2 6.2.6 / 6.3.4',
    'ISO/IEC 27002:2022 8.14',
    'NIST SP 800-53 PE-9(1)',
  ],
  'A-CTRL-02': <String>[
    'EN 50600-2-2 6.2 / 6.2.5 / 6.2.6',
    'BSI INF.2.A13',
    'NIST SP 800-53 PE-11',
  ],
  'A-CTRL-03': <String>[
    'BSI INF.2.A14',
    'NIST SP 800-53 PE-11',
    'EN 50600-2-2 6.2',
  ],
  'A-CTRL-04': <String>[
    'BSI INF.2.A19',
    'NIST SP 800-53 CP-4',
    'ISO 22301:2019 8.5',
  ],
  'A-CTRL-05': <String>[
    'EN 50600-2-3 / ISO/IEC 22237-4 6.2.2 / 6.4',
    'BSI INF.2.A16',
    'NIST SP 800-53 PE-14',
  ],
  'A-CTRL-06': <String>[
    'EN 50600-2-3 / ISO/IEC 22237-4 5.2.9 / 6.2.2',
    'BSI INF.2.A16',
    'ISO/IEC 27002:2022 7.8',
  ],
  'A-CTRL-07': <String>[
    'EN 50600-2-3 / ISO/IEC 22237-4 6.3 / 6.4',
    'ISO/IEC 27002:2022 8.6',
    'BSI INF.2.A16',
  ],
  'A-CTRL-08': <String>[
    'EN 50600-2-5 8.1.3',
    'BSI INF.2.A8',
    'BSI INF.2.A17',
  ],
  'A-CTRL-09': <String>[
    'EN 50600-2-5 8.1.4 / 8.2',
    'BSI INF.2.A9',
    'NIST SP 800-53 PE-13',
  ],
  'A-CTRL-10': <String>[
    'EN 50600-3-1 7.2 / Annex B.2',
    'BSI INF.2.A10',
    'ISO/IEC 27002:2022 7.13',
  ],
  'A-CTRL-11': <String>[
    'ISO/IEC 22237-2 8.9 / 10.1',
    'BSI INF.2.A11 / A29',
    'NIST SP 800-53 PE-15',
  ],
  'A-CTRL-12': <String>[
    'ISO/IEC 22237-2 8.7 / 8.10 / 8.11 / 8.13',
    'BSI INF.2.A7',
    'ISO/IEC 27002:2022 7.8',
  ],
  'A-CTRL-13': <String>[
    'ISO/IEC 22237-2 5.3.3 / 8.8 / 8.9 / 9.4 / 9.5',
    'BSI INF.1.A15',
    'BSI INF.2.A29',
  ],
  'A-CTRL-14': <String>[
    'ISO/IEC 27001:2022 5.3 / 7.2',
    'BSI ORP.1.A2',
    'BSI ORP.2.A15',
  ],
  'A-CTRL-15': <String>[
    'BSI INF.2.A10 / INF.12.A12',
    'ISO/IEC 27002:2022 7.13',
    'NIST SP 800-53 MA-2',
  ],
  'A-CTRL-16': <String>[
    'EN 50600-3-1 7.2 / 7.4',
    'BSI INF.12.A12',
    'NIST SP 800-53 MA-2',
  ],
  'A-CTRL-17': <String>[
    'BSI INF.2.A5',
    'ISO/IEC 22237-4 8.2 / 8.3 / Annex A',
    'NIST SP 800-53 PE-14',
  ],
  'B-CTRL-01': <String>[
    'ISO/IEC 27002:2022 7.2',
    'NIST SP 800-53 PE-2',
    'BSI INF.2.A6',
  ],
  'B-CTRL-02': <String>[
    'EN 50600-2-5 6.1.2 / 6.1.4',
    'NIST SP 800-53 PE-3',
    'ISO/IEC 27002:2022 7.2',
  ],
  'B-CTRL-03': <String>[
    'ISO/IEC 27002:2022 5.18',
    'ISO/IEC 27001:2022 5.3',
    'NIST SP 800-53 PE-2',
  ],
  'B-CTRL-04': <String>[
    'ISO/IEC 27002:2022 7.1',
    'EN 50600-2-5 5.3 / 6.2',
    'BSI INF.2.A12',
  ],
  'B-CTRL-05': <String>[
    'EN 50600-2-5 6.2 / 7',
    'ISO/IEC 27002:2022 7.1 / 7.2',
    'BSI INF.2.A12',
  ],
  'B-CTRL-06': <String>[
    'NIST SP 800-53 PE-16',
    'EN 50600-2-5 6.2.4 / 6.2.7',
    'ISO/IEC 27002:2022 7.1 / 7.2',
  ],
  'B-CTRL-07': <String>[
    'ISO/IEC 27002:2022 7.4',
    'NIST SP 800-53 PE-6',
    'EN 50600-2-5 11.2.2 / 11.2.5',
  ],
  'B-CTRL-08': <String>[
    'ISO/IEC 27002:2022 5.33',
    'ISO/IEC 27002:2022 8.3',
    'NIST SP 800-53 AC-6',
  ],
  'B-CTRL-09': <String>[
    'ISO/IEC 27002:2022 5.34',
    'ISO/IEC 27002:2022 8.10',
    'BSI CON.6.A2',
  ],
  'B-CTRL-10': <String>[
    'NIST SP 800-53 PE-8',
    'ISO/IEC 22237-6 6.2.6',
    'BSI INF.1.A26',
  ],
  'B-CTRL-11': <String>[
    'ISO/IEC 27002:2022 5.19 / 5.20',
    'NIST SP 800-53 PS-7',
    'BSI ORP.1.A14',
  ],
  'B-CTRL-12': <String>[
    'ISO/IEC 27002:2022 5.15 / 7.2',
    'NIST SP 800-53 PE-16',
    'BSI INF.1.A26',
  ],
  'B-CTRL-13': <String>[
    'ISO/IEC 27002:2022 7.1 / 7.2',
    'NIST SP 800-53 PE-3 / PE-18',
    'EN 50600-2-5 6.2 / 7',
  ],
  'B-CTRL-14': <String>[
    'ISO/IEC 27002:2022 7.2',
    'NIST SP 800-53 PE-3(1)',
    'BSI INF.2.A6 / INF.2.A12',
  ],
  'B-CTRL-15': <String>[
    'EN 50600-2-5 6.1.4 / 6.2',
    'NIST SP 800-53 PE-3',
    'ISO/IEC 27002:2022 7.2',
  ],
  'C-CTRL-01': <String>[
    'ISO/IEC 27002:2022 8.16',
    'NIST SP 800-53 SI-4',
    'EN 50600-3-1 6 / 7',
  ],
  'C-CTRL-02': <String>[
    'ISO/IEC 27002:2022 8.16',
    'NIST SP 800-53 SI-4 / IR-5',
    'EN 50600-3-1 7.3',
  ],
  'C-CTRL-03': <String>[
    'ISO/IEC 27002:2022 5.24 / 5.26',
    'NIST SP 800-53 IR-4 / IR-8',
    'ISO 22301:2019 8.4',
  ],
  'C-CTRL-04': <String>[
    'ISO/IEC 27002:2022 5.24 / 5.25 / 5.26',
    'NIST SP 800-53 IR-4',
    'BSI DER.4',
  ],
  'C-CTRL-05': <String>[
    'ISO/IEC 27002:2022 8.32',
    'NIST SP 800-53 CM-3 / CM-4',
    'BSI OPS.1.1.4.A3',
  ],
  'C-CTRL-06': <String>[
    'ISO/IEC 27002:2022 8.8',
    'NIST SP 800-53 MA-2',
    'EN 50600-3-1 7.2',
  ],
  'C-CTRL-07': <String>[
    'ISO/IEC 27002:2022 8.6',
    'EN 50600-2-3 6.3 / 6.4',
    'NIST SP 800-53 PE-14',
  ],
  'C-CTRL-08': <String>[
    'EN 50600-2-3 6.3 / 6.4',
    'ISO/IEC 27002:2022 8.6',
    'BSI INF.2.A16',
  ],
  'C-CTRL-09': <String>[
    'ISO/IEC 27002:2022 8.6',
    'ISO 22301:2019 8.3',
    'EN 50600-3-1 7.1',
  ],
  'C-CTRL-10': <String>[
    'ISO/IEC 27002:2022 5.37',
    'NIST SP 800-53 CM-8 / PL-2',
    'BSI OPS.1.1.1.A1',
  ],
  'C-CTRL-11': <String>[
    'ISO/IEC 27002:2022 8.9 / 8.32',
    'NIST SP 800-53 CM-8',
    'BSI OPS.1.1.1.A6',
  ],
  'C-CTRL-12': <String>[
    'ISO/IEC 27001:2022 9.1',
    'ISO 22301:2019 9.1',
    'NIST SP 800-53 PM-6',
  ],
  'C-CTRL-13': <String>[
    'ISO/IEC 27001:2022 9.1 / 10.1',
    'ISO 22301:2019 9.3 / 10.1',
    'NIST SP 800-53 CA-7',
  ],
  'C-CTRL-14': <String>[
    'ISO/IEC 27002:2022 5.19 / 5.20',
    'NIST SP 800-53 SR-3',
    'BSI ORP.1.A14',
  ],
  'C-CTRL-15': <String>[
    'ISO/IEC 27002:2022 5.22 / 5.23',
    'NIST SP 800-53 PS-7 / PE-16',
    'BSI INF.1.A26',
  ],
  'C-CTRL-16': <String>[
    'ISO/IEC 27002:2022 5.22',
    'ISO/IEC 27001:2022 9.3',
    'NIST SP 800-53 SR-6',
  ],
  'C-CTRL-17': <String>[
    'ISO/IEC 27002:2022 8.8',
    'NIST SP 800-53 SI-2',
    'BSI OPS.1.1.3.A16',
  ],
  'D-CTRL-01': <String>[
    'EN 50600-2-4 6.2 / 6.3',
    'ISO/IEC 27002:2022 8.21',
    'NIST SP 800-53 SC-5',
  ],
  'D-CTRL-02': <String>[
    'NIST SP 800-53 CP-8',
    'ISO/IEC 27002:2022 8.21',
    'EN 50600-2-4 6.3',
  ],
  'D-CTRL-03': <String>[
    'EN 50600-2-4 6.2 / 6.3',
    'NIST SP 800-53 PE-9(1)',
    'ISO/IEC 22237-5 6.2',
  ],
  'D-CTRL-04': <String>[
    'ISO/IEC 27002:2022 8.21',
    'NIST SP 800-53 SC-5',
    'EN 50600-2-4 6.3',
  ],
  'D-CTRL-05': <String>[
    'NIST SP 800-53 CP-8 / SC-24',
    'ISO/IEC 27002:2022 8.21',
    'EN 50600-2-4 6.3',
  ],
  'D-CTRL-06': <String>[
    'ISO/IEC 27002:2022 5.37 / 8.9',
    'NIST SP 800-53 CM-8',
    'BSI OPS.1.1.1.A1',
  ],
  'D-CTRL-07': <String>[
    'ISO/IEC 27002:2022 8.22',
    'NIST SP 800-53 SC-7',
    'BSI NET.1.1.A2',
  ],
  'D-CTRL-08': <String>[
    'ISO/IEC 27002:2022 8.20 / 8.22',
    'NIST SP 800-53 SC-7',
    'BSI NET.1.1.A3',
  ],
  'D-CTRL-09': <String>[
    'ISO/IEC 27002:2022 8.2 / 8.18 / 8.20',
    'NIST SP 800-53 AC-17 / AC-6',
    'BSI OPS.1.1.4.A8',
  ],
  'D-CTRL-10': <String>[
    'ISO/IEC 27002:2022 8.9',
    'EN 50600-2-4 6.4',
    'NIST SP 800-53 CM-8',
  ],
  'D-CTRL-11': <String>[
    'ISO/IEC 27002:2022 8.32',
    'NIST SP 800-53 CM-3',
    'BSI OPS.1.1.4.A3',
  ],
  'D-CTRL-12': <String>[
    'EN 50600-2-4 6.2 / 6.3',
    'ISO/IEC 27002:2022 8.21',
    'NIST SP 800-53 PE-9(1)',
  ],
  'D-CTRL-13': <String>[
    'ISO/IEC 27002:2022 8.20 / 8.21',
    'NIST SP 800-53 AC-17',
    'BSI OPS.1.1.4.A8',
  ],
  'D-CTRL-14': <String>[
    'ISO/IEC 27002:2022 8.2 / 8.5',
    'NIST SP 800-53 IA-2 / AC-6',
    'BSI OPS.1.1.4.A9',
  ],
  'D-CTRL-15': <String>[
    'ISO/IEC 27002:2022 5.30 / 8.2',
    'NIST SP 800-53 AC-2(4)',
    'ISO 22301:2019 8.4',
  ],
  'D-CTRL-16': <String>[
    'ISO/IEC 27002:2022 8.13 / 8.9',
    'NIST SP 800-53 CP-9',
    'BSI CON.3.A2',
  ],
  'E-CTRL-01': <String>[
    'ISO 22301:2019 5.3 / 5.4',
    'ISO/IEC 27001:2022 5.1 / 5.3',
    'BSI CON.1.A1',
  ],
  'E-CTRL-02': <String>[
    'ISO 22301:2019 7.2 / 7.3',
    'NIST SP 800-53 CP-2',
    'BSI DER.2.A1',
  ],
  'E-CTRL-03': <String>[
    'ISO 22301:2019 8.2 / 8.4',
    'ISO/IEC 27031 6 / 7',
    'NIST SP 800-53 CP-2 / CP-4',
  ],
  'E-CTRL-04': <String>[
    'ISO 22301:2019 8.3 / 8.4',
    'ISO/IEC 27031 7',
    'NIST SP 800-53 CP-2',
  ],
  'E-CTRL-05': <String>[
    'ISO/IEC 27031 7 / 8',
    'NIST SP 800-53 CP-7 / CP-8',
    'ISO 22301:2019 8.4',
  ],
  'E-CTRL-06': <String>[
    'ISO 22301:2019 8.5',
    'NIST SP 800-53 CP-4',
    'ISO/IEC 27031 8',
  ],
  'E-CTRL-07': <String>[
    'ISO 22301:2019 8.2 / 8.3',
    'ISO/IEC 27031 7.3',
    'NIST SP 800-53 CP-2',
  ],
  'E-CTRL-08': <String>[
    'ISO 22301:2019 8.3 / 8.4',
    'ISO/IEC 27031 7.4',
    'NIST SP 800-53 CP-2(2)',
  ],
  'E-CTRL-09': <String>[
    'ISO 22301:2019 8.4 / 8.5',
    'NIST SP 800-53 CP-10',
    'BSI DER.4.A3',
  ],
  'E-CTRL-10': <String>[
    'ISO 22301:2019 8.4',
    'NIST SP 800-53 CP-10',
    'ISO/IEC 27031 8.4',
  ],
  'E-CTRL-11': <String>[
    'ISO 22301:2019 7.5 / 8.5',
    'NIST SP 800-53 CP-2',
    'BSI DER.4.A4',
  ],
  'E-CTRL-12': <String>[
    'ISO 22301:2019 8.4',
    'NIST SP 800-53 IR-8 / CP-2',
    'BSI DER.2.A3',
  ],
  'E-CTRL-13': <String>[
    'ISO 22301:2019 8.4.3 / 8.4.4',
    'ISO/IEC 27035-1 8',
    'NIST SP 800-53 IR-4',
  ],
  'E-CTRL-14': <String>[
    'ISO/IEC 27002:2022 8.13',
    'NIST SP 800-53 CP-9',
    'BSI CON.3.A2',
  ],
};

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
            scoringModel: e.scoringModel,
            isFulfilled: false,
            criteria: List<String>.from(e.criteria),
            anchorCriteria: <int, List<String>>{
              for (final entry in e.anchorCriteria.entries)
                entry.key: List<String>.from(entry.value),
            },
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

  Future<void> _showControlMapping(ChecklistItem item) async {
    final references = _controlReferenceMapping[item.id] ?? const <String>[];

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Control Mapping ${item.id}'),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
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
    required Color color,
  }) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
    );
  }

  Widget _buildActiveDomainCard(_DomainGroup group) {
    final style = _styleForDomain(group.domainId);

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
      ],
      childWidgets: [
        ...group.items.map((item) => _buildActiveItemCard(item, style: style)),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildInactiveDomainCard(_DomainGroup group) {
    final style = _styleForDomain(group.domainId);

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
        ...group.items
            .map((item) => _buildInactiveItemCard(item, style: style)),
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
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _editMode ? () => _editItemDialog(item) : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(item.title)),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kritikalität ${item.riskLevel}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          tooltip: 'Control Mapping anzeigen',
                          onPressed: () => _showControlMapping(item),
                          icon: const Icon(Icons.info_outline),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                              width: 28, height: 28),
                        ),
                        IconButton(
                          tooltip: 'Aus Liste entfernen',
                          onPressed: () => _removeFromChecklist(item),
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                              width: 28, height: 28),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
          ),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Kritikalität ${item.riskLevel}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Control Mapping anzeigen',
                        onPressed: () => _showControlMapping(item),
                        icon: const Icon(Icons.info_outline),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                            width: 28, height: 28),
                      ),
                      IconButton(
                        tooltip: 'Zur Liste hinzufügen',
                        onPressed: () => _restoreToChecklist(item),
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                            width: 28, height: 28),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
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

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialItem?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialItem?.description ?? '');
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
      id: widget.initialItem?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      domainId: widget.initialItem?.domainId ?? '',
      domainName: widget.initialItem?.domainName ?? '',
      domainDescription: widget.initialItem?.domainDescription ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      riskLevel: _riskLevel,
      scoringModel:
          widget.initialItem?.scoringModel ?? ChecklistScoringModel.conformity,
      fulfilmentLevel: widget.initialItem?.fulfilmentLevel ?? 0,
      criteria:
          List<String>.from(widget.initialItem?.criteria ?? const <String>[]),
      anchorCriteria: <int, List<String>>{
        for (final entry in (widget.initialItem?.anchorCriteria ??
                const <int, List<String>>{})
            .entries)
          entry.key: List<String>.from(entry.value),
      },
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
