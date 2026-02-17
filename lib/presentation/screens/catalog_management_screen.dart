import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/providers/providers.dart';

class CatalogManagementScreen extends ConsumerWidget {
  const CatalogManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalogverwaltung')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Versionierung erfolgt über Feld "catalog_version" im JSON.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
                if (picked == null || picked.files.first.path == null) {
                  return;
                }
                final content = await File(picked.files.first.path!).readAsString();
                await ref.read(catalogRepositoryProvider).importCatalogJson(content);
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Katalog importiert.')));
                }
              },
              child: const Text('Katalog importieren (JSON)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                final content = await ref.read(catalogRepositoryProvider).exportCatalogJson();
                final docs = await getApplicationDocumentsDirectory();
                final path = p.join(docs.path, 'exports', 'catalog_export.json');
                final file = File(path);
                await file.parent.create(recursive: true);
                await file.writeAsString(content);
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Export gespeichert: $path')));
                }
              },
              child: const Text('Katalog exportieren (JSON)'),
            ),
          ],
        ),
      ),
    );
  }
}
