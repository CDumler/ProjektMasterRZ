import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rz_checkliste_risikoanalyse/domain/services/control_risk_service.dart';
import 'package:rz_checkliste_risikoanalyse/models/assessment_record.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class PdfReportFile {
  const PdfReportFile({
    required this.filePath,
    required this.fileName,
    required this.createdAt,
  });

  final String filePath;
  final String fileName;
  final DateTime createdAt;
}

class PdfReportGenerator {
  const PdfReportGenerator();

  static const _riskService = ControlRiskService();

  Future<PdfReportFile> generateAssessmentReport({
    required AssessmentRecord assessment,
    required String auditor,
    String? organization,
    String? location,
    String reportVersion = '1.0',
    String? confidentiality,
  }) async {
    final generatedAt = DateTime.now();
    final computed = _compute(assessment.items);
    final pdf = pw.Document();

    final displayDate = DateFormat('yyyy-MM-dd').format(generatedAt);
    final displayDateTime = DateFormat('yyyy-MM-dd HH:mm').format(generatedAt);
    final assessmentDate =
        DateFormat('yyyy-MM-dd').format(assessment.createdAt);

    final topThree = computed.sortedControls.take(3).toList(growable: false);
    final findings = _buildFindings(computed.sortedControls);
    final scopeRows = computed.domains
        .map((d) => <String>[
              d.label,
              '${d.controls.length}',
              d.coveragePercent,
            ])
        .toList(growable: false);
    final domainOverviewRows = computed.domains
        .map((d) => <String>[
              d.label,
              d.score.toStringAsFixed(2),
              d.riskClass,
              d.coveragePercent,
            ])
        .toList(growable: false);
    final domainRankingRows = computed.rankedDomains
        .map((d) => <String>[
              d.label,
              d.score.toStringAsFixed(2),
              d.riskClass,
            ])
        .toList(growable: false);
    final topRiskRows = computed.sortedControls
        .map((c) => <String>[
              c.item.id,
              c.item.title,
              c.domainLabel,
              '${c.item.riskLevel}',
              c.riskIndex.toStringAsFixed(2),
            ])
        .toList(growable: false);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Spacer(),
            pw.Text(
              'Datacenter Assessment Report',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 18),
            pw.Text(
              'Professional Audit Report',
              style: const pw.TextStyle(
                fontSize: 16,
                color: PdfColors.blueGrey700,
              ),
            ),
            pw.SizedBox(height: 26),
            _keyValue('Assessment', _safeText(assessment.name)),
            _keyValue('Organization / Site',
                '${_safeText(organization)} / ${_safeText(location)}'),
            _keyValue('Assessment Date', assessmentDate),
            _keyValue('Report Date', displayDate),
            _keyValue('Auditor / User', _safeText(auditor)),
            _keyValue('Domains', '${computed.domains.length}'),
            _keyValue('Controls', '${assessment.items.length}'),
            _keyValue('Report Version', reportVersion),
            _keyValue(
              'Confidentiality',
              confidentiality == null || confidentiality.trim().isEmpty
                  ? 'Internal'
                  : confidentiality.trim(),
            ),
            pw.Spacer(),
            pw.Text(
              'Generated at $displayDateTime',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 26, 32, 32),
        header: (_) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Datacenter Assessment Report',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.blueGrey700,
                ),
              ),
              pw.Text(
                _safeText(assessment.name),
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.blueGrey700,
                ),
              ),
            ],
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
        build: (_) => [
          _sectionTitle('2. Executive Summary'),
          pw.Text(
            'Dieses Assessment dokumentiert den aktuellen Reife- und Risikostand '
            'des betrachteten Rechenzentrums auf Basis der vorhandenen Controls.',
          ),
          pw.SizedBox(height: 8),
          _table(
            headers: const ['Metric', 'Value'],
            rows: [
              ['Assessed Controls', '${computed.assessedControls}'],
              ['Coverage', computed.totalCoveragePercent],
              ['Total Risk Score', computed.totalScore.toStringAsFixed(2)],
              ['Risk Class', computed.totalRiskClass],
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Top Risks',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          if (topThree.isEmpty)
            pw.Text('Keine Risiken vorhanden.')
          else
            ...topThree.asMap().entries.map(
                  (entry) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(
                      '${entry.key + 1}. ${entry.value.item.title}',
                    ),
                  ),
                ),
          pw.SizedBox(height: 14),
          _sectionTitle('3. Scope und Pruefungsrahmen'),
          pw.Text(
            'Gepruefte Domains und Umfang der bewerteten Controls innerhalb '
            'der aktiven Pruefung.',
          ),
          pw.SizedBox(height: 6),
          _table(
            headers: const ['Domain', 'Controls', 'Coverage'],
            rows: scopeRows,
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Pruefungsumfang: ${assessment.items.length} Controls in '
            '${computed.domains.length} Domains.',
          ),
          pw.SizedBox(height: 14),
          _sectionTitle('4. Bewertungsmethodik'),
          pw.Bullet(
            text: 'Controls besitzen Kritikalitaeten.',
          ),
          pw.Bullet(
            text: 'Bewertungen erzeugen eine Wirksamkeit.',
          ),
          pw.Bullet(
            text: 'RiskIndex = Criticality x (1 - Effectiveness).',
          ),
          pw.SizedBox(height: 6),
          _table(
            headers: const ['Risk Class', 'Score Range'],
            rows: const [
              ['Low', '0.00 - <1.25'],
              ['Medium', '1.25 - <2.50'],
              ['High', '2.50 - <3.75'],
              ['Critical', '3.75 - 5.00'],
            ],
          ),
          pw.SizedBox(height: 14),
          _sectionTitle('5. Gesamtuebersicht'),
          _table(
            headers: const ['Metric', 'Value'],
            rows: [
              ['Total Risk Score', computed.totalScore.toStringAsFixed(2)],
              ['Risk Class', computed.totalRiskClass],
              ['Coverage', computed.totalCoveragePercent],
            ],
          ),
          pw.SizedBox(height: 8),
          _table(
            headers: const ['Domain', 'Score', 'Risk Class', 'Coverage'],
            rows: domainOverviewRows,
          ),
          pw.SizedBox(height: 14),
          _sectionTitle('6. Domain Risk Overview'),
          _table(
            headers: const ['Domain', 'Score', 'Risk Class'],
            rows: domainRankingRows,
          ),
          pw.SizedBox(height: 14),
          _sectionTitle('7. Top Risks'),
          _table(
            headers: const [
              'Control ID',
              'Control Title',
              'Domain',
              'Criticality',
              'RiskIndex'
            ],
            rows: topRiskRows,
          ),
          pw.SizedBox(height: 14),
          _sectionTitle('8. Detailbewertung je Domain'),
          ...computed.rankedDomains.expand((domain) {
            final domainRows = domain.controls
                .map((control) => <String>[
                      control.item.id,
                      control.item.title,
                      control.status,
                      '${control.item.riskLevel}',
                      control.riskIndex.toStringAsFixed(2),
                    ])
                .toList(growable: false);

            return <pw.Widget>[
              pw.SizedBox(height: 6),
              pw.Text(
                domain.label,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              _table(
                headers: const [
                  'Control ID',
                  'Control Title',
                  'Status',
                  'Criticality',
                  'RiskIndex'
                ],
                rows: domainRows,
              ),
            ];
          }),
          pw.SizedBox(height: 14),
          _sectionTitle('9. Control Details'),
          ...computed.sortedControls.map(_controlDetailsBlock),
          pw.SizedBox(height: 14),
          _sectionTitle('10. Empfehlungen / Findings'),
          if (findings.isEmpty)
            pw.Text('Keine Findings vorhanden.')
          else
            ...findings,
          pw.SizedBox(height: 14),
          _sectionTitle('11. Fazit'),
          pw.Bullet(
            text:
                'Gesamtbewertung: ${computed.totalRiskClass} (${computed.totalScore.toStringAsFixed(2)}).',
          ),
          pw.Bullet(
            text: 'Coverage: ${computed.totalCoveragePercent}.',
          ),
          pw.Bullet(
            text:
                'Wichtigste Risiken: ${topThree.map((e) => e.item.title).join(', ')}.',
          ),
          pw.Bullet(
            text:
                'Verbesserungspotential liegt in der priorisierten Bearbeitung '
                'der Controls mit hohem RiskIndex.',
          ),
        ],
      ),
    );

    final reportsDir = await _reportsDirectory();
    final fileName =
        'assessment_report_${_slug(assessment.name)}_${DateFormat('yyyyMMdd').format(generatedAt)}.pdf';
    final targetPath = p.join(reportsDir.path, fileName);
    await File(targetPath).writeAsBytes(await pdf.save(), flush: true);

    return PdfReportFile(
      filePath: targetPath,
      fileName: fileName,
      createdAt: generatedAt,
    );
  }

  Future<Directory> _reportsDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final reports = Directory(p.join(docs.path, 'reports'));
    if (!reports.existsSync()) {
      reports.createSync(recursive: true);
    }
    return reports;
  }

  _ReportComputation _compute(List<ChecklistItem> items) {
    final controls = items.map((item) {
      final risk = _riskService.evaluateControl(item);
      return _ControlReportEntry(
        item: item,
        assessed: risk.assessed,
        riskIndex: risk.riskIndex,
        status: _statusFor(item),
        riskClass: _riskClassFromScore(risk.riskIndex),
      );
    }).toList(growable: false);

    final grouped = <String, List<_ControlReportEntry>>{};
    for (final control in controls) {
      grouped
          .putIfAbsent(control.item.domainId, () => <_ControlReportEntry>[])
          .add(control);
    }

    final domains = grouped.entries.map((entry) {
      final domainControls = entry.value.toList(growable: false)
        ..sort((a, b) => b.riskIndex.compareTo(a.riskIndex));
      final first = domainControls.first.item;
      final domainScore = domainControls.isEmpty
          ? 0.0
          : _roundTo(
              domainControls.map((e) => e.riskIndex).reduce((a, b) => a + b) /
                  domainControls.length,
            );
      final domainAssessed = domainControls.where((e) => e.assessed).length;
      final coverage =
          domainControls.isEmpty ? 0.0 : domainAssessed / domainControls.length;
      return _DomainReportEntry(
        id: first.domainId,
        name: first.domainName,
        score: domainScore,
        riskClass: _riskClassFromScore(domainScore),
        coverage: coverage,
        controls: domainControls,
      );
    }).toList(growable: false);

    final sortedControls = controls.toList(growable: false)
      ..sort((a, b) => b.riskIndex.compareTo(a.riskIndex));
    final rankedDomains = domains.toList(growable: false)
      ..sort((a, b) => b.score.compareTo(a.score));

    final totalScore = controls.isEmpty
        ? 0.0
        : _roundTo(
            controls.map((e) => e.riskIndex).reduce((a, b) => a + b) /
                controls.length,
          );
    final assessedControls = controls.where((e) => e.assessed).length;
    final totalCoverage =
        controls.isEmpty ? 0.0 : assessedControls / controls.length;

    return _ReportComputation(
      sortedControls: sortedControls,
      domains: domains,
      rankedDomains: rankedDomains,
      totalScore: totalScore,
      totalRiskClass: _riskClassFromScore(totalScore),
      totalCoverage: totalCoverage,
      assessedControls: assessedControls,
    );
  }

  List<pw.Widget> _buildFindings(List<_ControlReportEntry> controls) {
    final prioritized = controls.where((e) => e.riskIndex >= 2.5).toList();
    final findings = prioritized.isEmpty
        ? controls.take(3).toList(growable: false)
        : prioritized.take(10).toList(growable: false);

    return findings.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final control = entry.value;
      final criteriaHint = control.item.criteria.isNotEmpty
          ? control.item.criteria.first
          : 'Definieren und implementieren Sie konkrete Gegenmassnahmen.';

      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 10),
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Finding F-${index.toString().padLeft(2, '0')}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Description: ${control.item.title} '
              '(RiskIndex ${control.riskIndex.toStringAsFixed(2)}, '
              'Status: ${control.status}).',
            ),
            pw.SizedBox(height: 3),
            pw.Text('Recommendation: $criteriaHint'),
          ],
        ),
      );
    }).toList(growable: false);
  }

  pw.Widget _controlDetailsBlock(_ControlReportEntry control) {
    final evidenceText = control.item.evidence.isEmpty
        ? '-'
        : control.item.evidence
            .map((e) =>
                '${e.fileName} (${DateFormat('yyyy-MM-dd').format(e.addedAt)})')
            .join(', ');

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${control.item.id} - ${control.item.title}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          _keyValue('Description', _safeText(control.item.description)),
          _keyValue('Domain', control.domainLabel),
          _keyValue('Status', control.status),
          _keyValue('Criticality', '${control.item.riskLevel}'),
          _keyValue('RiskIndex', control.riskIndex.toStringAsFixed(2)),
          _keyValue('Risk Class', control.riskClass),
          _keyValue(
            'Criteria',
            control.item.criteria.isEmpty
                ? '-'
                : control.item.criteria.map((e) => '• $e').join('\n'),
          ),
          if (control.item.note.trim().isNotEmpty)
            _keyValue('Comment', control.item.note.trim()),
          if (control.item.evidence.isNotEmpty)
            _keyValue('Evidence', evidenceText),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _table({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    if (rows.isEmpty) {
      return pw.Text('Keine Daten vorhanden.');
    }
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      cellAlignments: {
        for (var i = 0; i < headers.length; i++) i: pw.Alignment.centerLeft,
      },
    );
  }

  static pw.Widget _keyValue(String key, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              key,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  static String _safeText(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? '-' : trimmed;
  }

  static String _statusFor(ChecklistItem item) {
    switch (item.fulfilmentLevel) {
      case 2:
        return 'Fulfilled';
      case 1:
        return 'Partially fulfilled';
      default:
        return 'Not fulfilled';
    }
  }

  static String _riskClassFromScore(double score) {
    final safe = score.clamp(0.0, 5.0);
    if (safe < 1.25) {
      return 'Low';
    }
    if (safe < 2.50) {
      return 'Medium';
    }
    if (safe < 3.75) {
      return 'High';
    }
    return 'Critical';
  }

  static double _roundTo(double value) {
    return (value * 100).roundToDouble() / 100;
  }

  static String _slug(String input) {
    final normalized = input
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return normalized.isEmpty ? 'assessment' : normalized;
  }
}

class _ControlReportEntry {
  const _ControlReportEntry({
    required this.item,
    required this.assessed,
    required this.riskIndex,
    required this.status,
    required this.riskClass,
  });

  final ChecklistItem item;
  final bool assessed;
  final double riskIndex;
  final String status;
  final String riskClass;

  String get domainLabel {
    final id = item.domainId.trim();
    final name = item.domainName.trim();
    if (id.isEmpty && name.isEmpty) {
      return '-';
    }
    if (id.isEmpty) {
      return name;
    }
    if (name.isEmpty) {
      return 'Domain $id';
    }
    return 'Domain $id: $name';
  }
}

class _DomainReportEntry {
  const _DomainReportEntry({
    required this.id,
    required this.name,
    required this.score,
    required this.riskClass,
    required this.coverage,
    required this.controls,
  });

  final String id;
  final String name;
  final double score;
  final String riskClass;
  final double coverage;
  final List<_ControlReportEntry> controls;

  String get label {
    if (id.trim().isEmpty && name.trim().isEmpty) {
      return '-';
    }
    if (id.trim().isEmpty) {
      return name;
    }
    if (name.trim().isEmpty) {
      return 'Domain $id';
    }
    return 'Domain $id: $name';
  }

  String get coveragePercent => '${(coverage * 100).toStringAsFixed(0)}%';
}

class _ReportComputation {
  const _ReportComputation({
    required this.sortedControls,
    required this.domains,
    required this.rankedDomains,
    required this.totalScore,
    required this.totalRiskClass,
    required this.totalCoverage,
    required this.assessedControls,
  });

  final List<_ControlReportEntry> sortedControls;
  final List<_DomainReportEntry> domains;
  final List<_DomainReportEntry> rankedDomains;
  final double totalScore;
  final String totalRiskClass;
  final double totalCoverage;
  final int assessedControls;

  String get totalCoveragePercent =>
      '${(totalCoverage * 100).toStringAsFixed(0)}%';
}
