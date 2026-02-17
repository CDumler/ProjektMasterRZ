import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PickedEvidence {
  const PickedEvidence({
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.hash,
    required this.hashAlg,
  });

  final String filePath;
  final String fileName;
  final String mimeType;
  final String hash;
  final String hashAlg;
}

class EvidenceService {
  Future<PickedEvidence?> pickAndStore(String assessmentId) async {
    final picked = await FilePicker.platform.pickFiles(withData: false);
    if (picked == null || picked.files.isEmpty) {
      return null;
    }

    final source = picked.files.first;
    if (source.path == null) {
      return null;
    }

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'evidence', assessmentId));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final targetPath = p.join(dir.path, source.name);
    final srcFile = File(source.path!);
    await srcFile.copy(targetPath);

    final bytes = await File(targetPath).readAsBytes();
    final hash = sha256.convert(bytes).toString();

    return PickedEvidence(
      filePath: targetPath,
      fileName: source.name,
      mimeType: source.extension ?? 'application/octet-stream',
      hash: hash,
      hashAlg: 'SHA-256',
    );
  }
}
