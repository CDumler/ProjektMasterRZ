import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';

class ExportArtifacts {
  const ExportArtifacts({
    required this.jsonPath,
    required this.csvFindingsPath,
    required this.csvRisksPath,
    required this.csvAnswersPath,
    required this.pdfPath,
    required this.evidenceZipPath,
  });

  final String jsonPath;
  final String csvFindingsPath;
  final String csvRisksPath;
  final String csvAnswersPath;
  final String pdfPath;
  final String evidenceZipPath;
}

class ExportService {
  Future<Directory> _exportDir(Assessment assessment) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'exports', assessment.id));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  Future<ExportArtifacts> exportAll({
    required Assessment assessment,
    required List<ItemAnswer> answers,
    required List<Finding> findings,
    required List<RiskRecord> risks,
    required List<Evidence> evidence,
  }) async {
    final dir = await _exportDir(assessment);

    final jsonPath = p.join(dir.path, '${assessment.id}_full.json');
    final csvFindings = p.join(dir.path, '${assessment.id}_findings.csv');
    final csvRisks = p.join(dir.path, '${assessment.id}_risks.csv');
    final csvAnswers = p.join(dir.path, '${assessment.id}_answers.csv');
    final pdfPath = p.join(dir.path, '${assessment.id}_report.pdf');
    final zipPath = p.join(dir.path, '${assessment.id}_evidence.zip');

    final full = {
      'assessment': assessment.toJson(),
      'answers': answers.map((e) => e.toJson()).toList(),
      'findings': findings.map((e) => e.toJson()).toList(),
      'risks': risks.map((e) => e.toJson()).toList(),
      'evidence': evidence.map((e) => e.toJson()).toList(),
    };
    await File(jsonPath).writeAsString(jsonEncode(full));

    await File(csvFindings).writeAsString(
      const ListToCsvConverter().convert([
        ['id', 'controlItemId', 'type', 'severity', 'status', 'title'],
        ...findings.map((f) => [f.id, f.controlItemId, f.type.name, f.severity.name, f.status.name, f.title]),
      ]),
    );

    await File(csvRisks).writeAsString(
      const ListToCsvConverter().convert([
        ['id', 'findingId', 'likelihood', 'impact', 'score', 'riskClass', 'rationale'],
        ...risks.map((r) => [r.id, r.findingId, r.likelihood, r.impact, r.score, r.riskClass.name, r.rationale]),
      ]),
    );

    await File(csvAnswers).writeAsString(
      const ListToCsvConverter().convert([
        ['id', 'controlItemId', 'scoreType', 'fulfilment', 'maturity', 'answeredBy', 'answeredAt'],
        ...answers.map((a) => [
              a.id,
              a.controlItemId,
              a.scoreType.name,
              a.fulfilmentEnum?.name,
              a.maturityLevel,
              a.answeredBy,
              a.answeredAt.toIso8601String(),
            ]),
      ]),
    );

    await _createPdf(
      path: pdfPath,
      assessment: assessment,
      findings: findings,
      risks: risks,
      answers: answers,
      evidence: evidence,
    );

    await _createEvidenceZip(zipPath, evidence, assessment);

    return ExportArtifacts(
      jsonPath: jsonPath,
      csvFindingsPath: csvFindings,
      csvRisksPath: csvRisks,
      csvAnswersPath: csvAnswers,
      pdfPath: pdfPath,
      evidenceZipPath: zipPath,
    );
  }

  Future<void> _createPdf({
    required String path,
    required Assessment assessment,
    required List<Finding> findings,
    required List<RiskRecord> risks,
    required List<ItemAnswer> answers,
    required List<Evidence> evidence,
  }) async {
    final pdf = pw.Document();
    final topRisks = [...risks]..sort((a, b) => b.score.compareTo(a.score));

    pdf.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Text('RZ-Checkliste & Risikoanalyse Report',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Assessment: ${assessment.name}'),
          pw.Text('Organisation: ${assessment.org}'),
          pw.Text('Standort: ${assessment.location}'),
          pw.Text('Status: ${assessment.status.name}'),
          pw.Text('Katalogversion: ${assessment.catalogVersion}'),
          pw.SizedBox(height: 16),
          pw.Text('Executive Summary', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Antworten: ${answers.length}'),
          pw.Text('Findings offen: ${findings.where((f) => f.status.name != 'resolved').length}'),
          pw.Text('Risiken gesamt: ${risks.length}'),
          pw.SizedBox(height: 10),
          pw.Text('Top Risiken', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...topRisks.take(5).map((r) => pw.Text('${r.id}: Score ${r.score} (${r.riskClass.name})')),
          pw.SizedBox(height: 16),
          pw.Text('Detail Findings', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...findings.take(20).map((f) => pw.Text('${f.title} | ${f.severity.name} | ${f.status.name}')),
          pw.SizedBox(height: 16),
          pw.Text('Evidenzstatus', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...evidence.take(20).map((e) => pw.Text('${e.fileName}: ${e.status.name} (${e.confidentiality})')),
        ],
      ),
    );

    await File(path).writeAsBytes(await pdf.save());
  }

  Future<void> _createEvidenceZip(String zipPath, List<Evidence> entries, Assessment assessment) async {
    final archive = Archive();
    final manifest = <Map<String, dynamic>>[];
    for (final e in entries) {
      final file = File(e.filePath);
      if (!file.existsSync()) {
        continue;
      }
      final bytes = file.readAsBytesSync();
      final entryPath = '${assessment.id}/${e.linkedEntityType.name}/${e.linkedEntityId}/${e.fileName}';
      archive.addFile(ArchiveFile(entryPath, bytes.length, bytes));
      manifest.add(e.toJson());
    }

    final manifestBytes = utf8.encode(jsonEncode({'assessmentId': assessment.id, 'evidence': manifest}));
    archive.addFile(ArchiveFile('${assessment.id}/manifest.json', manifestBytes.length, manifestBytes));

    final output = ZipEncoder().encode(archive);
    if (output == null) {
      throw StateError('ZIP encoding failed');
    }
    await File(zipPath).writeAsBytes(output, flush: true);
  }
}
