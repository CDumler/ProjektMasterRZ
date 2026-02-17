import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class EvidenceScreen extends ConsumerStatefulWidget {
  const EvidenceScreen({super.key, required this.assessmentId});

  final String assessmentId;

  @override
  ConsumerState<EvidenceScreen> createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends ConsumerState<EvidenceScreen> {
  EvidenceStatus? filter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Evidence>>(
      future: ref.read(workRepositoryProvider).listEvidence(widget.assessmentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        var list = snapshot.data!;
        if (filter != null) {
          list = list.where((e) => e.status == filter).toList(growable: false);
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Evidenzen')),
          body: Column(
            children: [
              DropdownButton<EvidenceStatus?>(
                value: filter,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Alle Status')),
                  ...EvidenceStatus.values
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                      .toList(growable: false),
                ],
                onChanged: (v) => setState(() => filter = v),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final e = list[index];
                    return ListTile(
                      title: Text(e.fileName),
                      subtitle: Text('${e.status.name} • ${e.owner} • ${e.confidentiality}'),
                      trailing: Text(e.hashAlg ?? ''),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
