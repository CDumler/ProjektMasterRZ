import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final assessmentsAsync = ref.watch(assessmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RZ-Checkliste & Kritikalitätsanalyse'),
        actions: [
          IconButton(
              onPressed: () => context.push('/catalog'),
              icon: const Icon(Icons.library_books)),
          IconButton(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _createAssessment(context);
          ref.invalidate(assessmentsProvider);
        },
        label: const Text('Neues Assessment'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Suche Assessment',
              ),
              onChanged: (v) => setState(() => _filter = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: assessmentsAsync.when(
              data: (assessments) {
                final filtered = assessments
                    .where((a) =>
                        a.name.toLowerCase().contains(_filter) ||
                        a.org.toLowerCase().contains(_filter))
                    .toList(growable: false);
                if (filtered.isEmpty) {
                  return const Center(
                      child: Text('Keine Assessments vorhanden.'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final asm = filtered[index];
                    return ListTile(
                      title: Text(asm.name),
                      subtitle: Text(
                          '${asm.org} • ${asm.location} • ${asm.status.name}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/assessment/${asm.id}'),
                    );
                  },
                );
              },
              error: (e, _) => Center(child: Text('Fehler: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createAssessment(BuildContext context) async {
    final name = TextEditingController();
    final org = TextEditingController();
    final location = TextEditingController();
    final role = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Neues Assessment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: org,
                  decoration: const InputDecoration(labelText: 'Organisation')),
              TextField(
                  controller: location,
                  decoration: const InputDecoration(labelText: 'Standort')),
              TextField(
                  controller: role,
                  decoration: const InputDecoration(
                      labelText: 'Verantwortliche Rolle')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Abbrechen')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Anlegen')),
        ],
      ),
    );

    if (ok != true || !mounted) {
      return;
    }

    final orchestrator = ref.read(orchestratorProvider);
    await orchestrator.createAssessment(
      name: name.text.isEmpty ? 'Neues Assessment' : name.text,
      org: org.text.isEmpty ? 'Unbekannt' : org.text,
      location: location.text.isEmpty ? 'On-Prem Standort' : location.text,
      contextProfileId: 'ctx-default',
      catalogVersion: 'v1',
      responsibleRole: role.text,
    );
  }
}
