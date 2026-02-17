import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/audit_chain_service.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key, required this.assessmentId});

  final String assessmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(auditRepositoryProvider).listByAssessment(assessmentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final entries = snapshot.data!;
        final verified = const AuditChainService().verifyChain(entries);

        return Scaffold(
          appBar: AppBar(title: const Text('Audit-Trail')),
          body: Column(
            children: [
              ListTile(
                title: const Text('Hashkette'),
                subtitle: Text(verified ? 'Integrität verifiziert' : 'Integrität NICHT verifiziert'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final e = entries[index];
                    return ListTile(
                      title: Text('${e.eventType.name} ${e.entityType.name}'),
                      subtitle: Text('${e.timestamp.toIso8601String()} • ${e.actor} • ${e.entityId}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
