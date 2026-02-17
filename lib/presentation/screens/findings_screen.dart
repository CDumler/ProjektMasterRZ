import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class FindingsScreen extends ConsumerStatefulWidget {
  const FindingsScreen({super.key, required this.assessmentId});

  final String assessmentId;

  @override
  ConsumerState<FindingsScreen> createState() => _FindingsScreenState();
}

class _FindingsScreenState extends ConsumerState<FindingsScreen> {
  bool onlyOpen = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Finding>>(
      future: ref.read(workRepositoryProvider).listFindings(widget.assessmentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Fehler: ${snapshot.error}')));
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        var findings = snapshot.data!;
        if (onlyOpen) {
          findings = findings.where((f) => f.status.name == 'open').toList(growable: false);
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Findings')),
          body: Column(
            children: [
              SwitchListTile(
                title: const Text('Nur offene Findings'),
                value: onlyOpen,
                onChanged: (v) => setState(() => onlyOpen = v),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: findings.length,
                  itemBuilder: (context, index) {
                    final f = findings[index];
                    return ExpansionTile(
                      title: Text(f.title),
                      subtitle: Text('${f.type.name} • ${f.severity.name} • ${f.status.name}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(f.description),
                        )
                      ],
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
