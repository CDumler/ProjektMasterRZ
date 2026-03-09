import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/data/checklist_catalog.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/control_risk_service.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class RiskAnalysisScreen extends StatelessWidget {
  const RiskAnalysisScreen({super.key, required this.items});

  final List<ChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    final total = _RiskComputation.buildTotal(items);
    final allCatalogRisks = _buildAllCatalogRisks(items);
    final topRisks = total.topRisks.take(10).toList(growable: false);
    final rankedDomains = total.domains.toList(growable: false)
      ..sort((a, b) {
        final scoreOrder = b.domainScore.compareTo(a.domainScore);
        if (scoreOrder != 0) {
          return scoreOrder;
        }
        final idA = a.domainId.isEmpty ? 'Z' : a.domainId;
        final idB = b.domainId.isEmpty ? 'Z' : b.domainId;
        return idA.compareTo(idB);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Kritikalitätsanalyse · Gesamt')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GlobalOverviewCard(total: total),
          const SizedBox(height: 14),
          Text(
            'Domain Risk Ranking',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (rankedDomains.isEmpty)
            const Card(
              child: ListTile(title: Text('Keine Domänendaten vorhanden.')),
            )
          else
            ...rankedDomains.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final domain = entry.value;
              final style = _styleForDomain(domain.domainId);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: style.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: style.border, width: 1.2),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: style.accent.withValues(alpha: 0.12),
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        color: style.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          domain.domainId.isEmpty
                              ? domain.domainName
                              : 'Domäne ${domain.domainId}: ${domain.domainName}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'score: ${domain.domainScore.toStringAsFixed(2)} · risk_class: ${domain.riskClass}\ncoverage: ${_formatCoverage(domain.coverage)}',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: style.accent),
                  onTap: () => _replaceWith(
                    context,
                    DomainRiskScreen(
                      items: items,
                      domainId: domain.domainId,
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Top Risks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: allCatalogRisks.isEmpty
                    ? null
                    : () => _showAllControlsSheet(
                          context: context,
                          allRisks: allCatalogRisks,
                          items: items,
                        ),
                child: const Text('Mehr -'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (topRisks.isEmpty)
            const Card(
              child: ListTile(title: Text('Keine Risiken vorhanden.')),
            )
          else
            ...topRisks.asMap().entries.map(
              (entry) {
                final rank = entry.key + 1;
                final risk = entry.value;
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                      ),
                      child: Text(
                        '$rank',
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(risk.control.title),
                    subtitle: Text(
                      'domain_id: ${risk.control.domainId} · risk_index: ${risk.riskIndex.toStringAsFixed(2)} · risk_class: ${risk.riskClass}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _replaceWith(
                      context,
                      ControlRiskScreen(
                        items: items,
                        controlId: risk.control.id,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class DomainRiskScreen extends StatelessWidget {
  const DomainRiskScreen({
    super.key,
    required this.items,
    required this.domainId,
  });

  final List<ChecklistItem> items;
  final String domainId;

  @override
  Widget build(BuildContext context) {
    final total = _RiskComputation.buildTotal(items);
    final domain =
        total.domains.where((d) => d.domainId == domainId).firstOrNull;

    if (domain == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kritikalitätsanalyse · Domain')),
        body: const Center(child: Text('Domäne nicht gefunden.')),
      );
    }

    final sorted = domain.controls.toList()
      ..sort((a, b) => b.riskIndex.compareTo(a.riskIndex));
    final rankByControlId = <String, int>{
      for (final entry in sorted.asMap().entries)
        entry.value.control.id: entry.key + 1,
    };
    final notFulfilled = sorted.where((risk) {
      if (risk.control.usesMaturityScoring) {
        return risk.control.fulfilmentLevel <= 1;
      }
      return risk.control.fulfilmentLevel == 0;
    }).toList();
    final partiallyFulfilled = sorted.where((risk) {
      if (risk.control.usesMaturityScoring) {
        final level = risk.control.fulfilmentLevel;
        return level >= 2 && level < 4;
      }
      return risk.control.fulfilmentLevel == 1;
    }).toList();
    final fulfilled = sorted.where((risk) {
      if (risk.control.usesMaturityScoring) {
        return risk.control.fulfilmentLevel >= 4;
      }
      return risk.control.fulfilmentLevel == 2;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kritikalitätsanalyse · Domain')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ScoreCard(
            title: domain.domainId.isEmpty
                ? 'Risikoübersicht · ${domain.domainName}'
                : 'Risikoübersicht · Domäne ${domain.domainId}: ${domain.domainName}',
            score: domain.domainScore,
            riskClass: domain.riskClass,
            subtitle:
                '${domain.domainDescription}\ncoverage: ${_formatCoverage(domain.coverage)}',
          ),
          const SizedBox(height: 6),
          Text(
            'Kontrollen nach Erfüllungsstatus (domain-intern priorisiert)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _FulfilmentControlsSection(
            title: 'Nicht erfüllt',
            color: const Color(0xFFB91C1C),
            controls: notFulfilled,
            items: items,
            rankByControlId: rankByControlId,
          ),
          _FulfilmentControlsSection(
            title: 'Teilweise erfüllt',
            color: const Color(0xFFCA8A04),
            controls: partiallyFulfilled,
            items: items,
            rankByControlId: rankByControlId,
          ),
          _FulfilmentControlsSection(
            title: 'Erfüllt',
            color: const Color(0xFF15803D),
            controls: fulfilled,
            items: items,
            rankByControlId: rankByControlId,
          ),
        ],
      ),
    );
  }
}

class _FulfilmentControlsSection extends StatelessWidget {
  const _FulfilmentControlsSection({
    required this.title,
    required this.color,
    required this.controls,
    required this.items,
    required this.rankByControlId,
  });

  final String title;
  final Color color;
  final List<_ControlRiskResult> controls;
  final List<ChecklistItem> items;
  final Map<String, int> rankByControlId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.38)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(12, 6, 10, 6),
          title: Text(
            '$title (${controls.length})',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          iconColor: color,
          collapsedIconColor: color,
          children: [
            if (controls.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Keine Controls in diesem Status.'),
                ),
              )
            else
              ...controls.map((risk) {
                final rank = rankByControlId[risk.control.id];
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
                    leading: rank == null
                        ? null
                        : Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFD1D5DB)),
                            ),
                            child: Text(
                              '$rank',
                              style: const TextStyle(
                                color: Color(0xFF374151),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                    title: Text(risk.control.title),
                    subtitle: Text(
                      'risk_index: ${risk.riskIndex.toStringAsFixed(2)} · risk_class: ${risk.riskClass}\nStatus: ${risk.mode} | ${risk.assessmentDisplay}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _replaceWith(
                      context,
                      ControlRiskScreen(
                        items: items,
                        controlId: risk.control.id,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class ControlRiskScreen extends StatelessWidget {
  const ControlRiskScreen({
    super.key,
    required this.items,
    required this.controlId,
  });

  final List<ChecklistItem> items;
  final String controlId;

  @override
  Widget build(BuildContext context) {
    final control = items.where((e) => e.id == controlId).firstOrNull;

    if (control == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kritikalitätsanalyse · Control')),
        body: const Center(child: Text('Control nicht gefunden.')),
      );
    }

    final risk = _RiskComputation.evaluateControl(control);

    return Scaffold(
      appBar: AppBar(title: const Text('Kritikalitätsanalyse · Control')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    control.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(control.description),
                  const SizedBox(height: 12),
                  _MetricRow(
                    label: 'control.criticality (K)',
                    value: '${control.riskLevel}',
                  ),
                  _MetricRow(
                    label: 'assessment_result.mode',
                    value: risk.mode,
                  ),
                  _MetricRow(
                    label: 'assessment_result.value',
                    value: risk.assessmentDisplay,
                  ),
                  _MetricRow(
                    label: 'effectiveness_E',
                    value: risk.effectivenessE.toStringAsFixed(2),
                  ),
                  _MetricRow(
                    label: 'gap_G',
                    value: risk.gapG.toStringAsFixed(2),
                  ),
                  _MetricRow(
                    label: 'risk_index',
                    value: risk.riskIndex.toStringAsFixed(2),
                  ),
                  _MetricRow(label: 'risk_class', value: risk.riskClass),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criteria (read-only)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (control.criteria.isEmpty)
                    const Text('Keine Kriterien vorhanden.')
                  else
                    ...control.criteria.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $c'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.title,
    required this.score,
    required this.riskClass,
    required this.subtitle,
  });

  final String title;
  final double score;
  final String riskClass;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final color = _riskClassColor(riskClass);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            score.toStringAsFixed(2),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text('Risikoklasse: $riskClass', style: TextStyle(color: color)),
          const SizedBox(height: 4),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _GlobalOverviewCard extends StatelessWidget {
  const _GlobalOverviewCard({required this.total});

  final _TotalRiskResult total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Global Risk Overview',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            _MetricRow(
              label: 'Total Risk Score',
              value: total.totalScore.toStringAsFixed(2),
            ),
            _MetricRow(label: 'Risk Class', value: total.totalRiskClass),
            _MetricRow(
                label: 'Coverage', value: _formatCoverage(total.totalCoverage)),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}

class _ControlRiskResult {
  const _ControlRiskResult({
    required this.control,
    required this.mode,
    required this.assessmentValue,
    required this.effectivenessE,
    required this.gapG,
    required this.riskIndex,
    required this.riskClass,
    required this.assessed,
  });

  final ChecklistItem control;
  final String mode;
  final double assessmentValue;
  final double effectivenessE;
  final double gapG;
  final double riskIndex;
  final String riskClass;
  final bool assessed;

  String get assessmentDisplay {
    if (mode != 'MODE_MATURITY') {
      return assessmentValue.toStringAsFixed(2);
    }
    final roundedScore = assessmentValue.round().clamp(0, 5);
    final levelName = maturityLevelLabel(roundedScore);
    return '${assessmentValue.toStringAsFixed(2)} ($roundedScore $levelName)';
  }
}

class _DomainRiskResult {
  const _DomainRiskResult({
    required this.domainId,
    required this.domainName,
    required this.domainDescription,
    required this.domainScore,
    required this.riskClass,
    required this.coverage,
    required this.controls,
  });

  final String domainId;
  final String domainName;
  final String domainDescription;
  final double domainScore;
  final String riskClass;
  final double coverage;
  final List<_ControlRiskResult> controls;
}

class _TotalRiskResult {
  const _TotalRiskResult({
    required this.totalScore,
    required this.totalRiskClass,
    required this.totalCoverage,
    required this.domains,
    required this.topRisks,
  });

  final double totalScore;
  final String totalRiskClass;
  final double totalCoverage;
  final List<_DomainRiskResult> domains;
  final List<_ControlRiskResult> topRisks;
}

class _RiskComputation {
  static const _scoreService = ControlRiskService();

  static _ControlRiskResult evaluateControl(ChecklistItem control) {
    final computed = _scoreService.evaluateControl(control);

    return _ControlRiskResult(
      control: control,
      mode: computed.modeToken,
      assessmentValue: computed.assessmentValue,
      effectivenessE: computed.effectiveness,
      gapG: computed.gap,
      riskIndex: computed.riskIndex,
      riskClass: _riskClassFromScore(computed.riskIndex),
      assessed: computed.assessed,
    );
  }

  static _TotalRiskResult buildTotal(List<ChecklistItem> items) {
    final controls = items.map(evaluateControl).toList(growable: false);
    final byDomain = <String, List<_ControlRiskResult>>{};

    for (final control in controls) {
      final key = control.control.domainId;
      byDomain.putIfAbsent(key, () => <_ControlRiskResult>[]).add(control);
    }

    final domains = byDomain.entries.map((entry) {
      final list = entry.value;
      final first = list.first.control;
      final score = list.isEmpty
          ? 0.0
          : _roundTo(
              list.map((c) => c.riskIndex).reduce((a, b) => a + b) /
                  list.length,
            );
      final assessed = list.where((c) => c.assessed).length;
      final coverage = list.isEmpty ? 0.0 : assessed / list.length;

      return _DomainRiskResult(
        domainId: first.domainId,
        domainName: first.domainName,
        domainDescription: first.domainDescription,
        domainScore: score,
        riskClass: _riskClassFromScore(score),
        coverage: coverage,
        controls: list,
      );
    }).toList()
      ..sort((a, b) {
        final idA = a.domainId.isEmpty ? 'Z' : a.domainId;
        final idB = b.domainId.isEmpty ? 'Z' : b.domainId;
        return idA.compareTo(idB);
      });

    final totalScore = controls.isEmpty
        ? 0.0
        : _roundTo(
            controls.map((c) => c.riskIndex).reduce((a, b) => a + b) /
                controls.length,
          );
    final assessedControls = controls.where((c) => c.assessed).length;
    final totalCoverage =
        controls.isEmpty ? 0.0 : assessedControls / controls.length;
    final top = controls.toList()
      ..sort((a, b) => b.riskIndex.compareTo(a.riskIndex));

    return _TotalRiskResult(
      totalScore: totalScore,
      totalRiskClass: _riskClassFromScore(totalScore),
      totalCoverage: totalCoverage,
      domains: domains,
      topRisks: top,
    );
  }

  static double _roundTo(double value) {
    return (value * 100).roundToDouble() / 100;
  }
}

Color _riskClassColor(String riskClass) {
  switch (riskClass) {
    case 'Low':
    case 'Niedrig':
      return const Color(0xFF15803D);
    case 'Medium':
    case 'Mittel':
      return const Color(0xFFB45309);
    case 'High':
    case 'Hoch':
      return const Color(0xFFB91C1C);
    case 'Critical':
    case 'Kritisch':
      return const Color(0xFF7F1D1D);
    default:
      return Colors.blueGrey;
  }
}

String _riskClassFromScore(double score) {
  final safeScore = score.clamp(0.0, 5.0);
  if (safeScore < 1.25) {
    return 'Low';
  }
  if (safeScore < 2.50) {
    return 'Medium';
  }
  if (safeScore < 3.75) {
    return 'High';
  }
  return 'Critical';
}

String _formatCoverage(double coverage) {
  final clamped = math.max(0.0, math.min(1.0, coverage));
  final pct = (clamped * 100).toStringAsFixed(0);
  return '$pct% (${clamped.toStringAsFixed(2)})';
}

void _showAllControlsSheet({
  required BuildContext context,
  required List<_ControlRiskResult> allRisks,
  required List<ChecklistItem> items,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      String domainFilter = 'Alle';
      String criticalityFilter = 'Alle';
      final domains = allRisks
          .map((e) => e.control.domainId)
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      return StatefulBuilder(
        builder: (context, setSheetState) {
          final criticality = int.tryParse(criticalityFilter);
          final filtered = allRisks.where((risk) {
            final matchesDomain =
                domainFilter == 'Alle' || risk.control.domainId == domainFilter;
            final matchesCriticality =
                criticality == null || risk.control.riskLevel == criticality;
            return matchesDomain && matchesCriticality;
          }).toList(growable: false);

          return SafeArea(
            child: FractionallySizedBox(
              heightFactor: 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          'Alle Controls',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: const Text('Schließen'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownMenu<String>(
                            key: ValueKey<String>('domain:$domainFilter'),
                            initialSelection: domainFilter,
                            label: const Text('Domäne'),
                            expandedInsets: EdgeInsets.zero,
                            dropdownMenuEntries: [
                              const DropdownMenuEntry<String>(
                                value: 'Alle',
                                label: 'Alle',
                              ),
                              ...domains.map(
                                (domainId) => DropdownMenuEntry<String>(
                                  value: domainId,
                                  label: 'Domäne $domainId',
                                ),
                              ),
                            ],
                            onSelected: (value) => setSheetState(
                              () => domainFilter = value ?? 'Alle',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownMenu<String>(
                            key: ValueKey<String>(
                              'criticality:$criticalityFilter',
                            ),
                            initialSelection: criticalityFilter,
                            label: const Text('Kritikalität'),
                            expandedInsets: EdgeInsets.zero,
                            dropdownMenuEntries: const [
                              DropdownMenuEntry<String>(
                                value: 'Alle',
                                label: 'Alle',
                              ),
                              DropdownMenuEntry<String>(value: '1', label: '1'),
                              DropdownMenuEntry<String>(value: '2', label: '2'),
                              DropdownMenuEntry<String>(value: '3', label: '3'),
                              DropdownMenuEntry<String>(value: '4', label: '4'),
                              DropdownMenuEntry<String>(value: '5', label: '5'),
                            ],
                            onSelected: (value) => setSheetState(
                              () => criticalityFilter = value ?? 'Alle',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text('Keine Controls für diesen Filter.'),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final risk = filtered[index];
                              return ListTile(
                                title: Text(risk.control.title),
                                subtitle: Text(
                                  'domain_id: ${risk.control.domainId} · criticality: ${risk.control.riskLevel} · risk_index: ${risk.riskIndex.toStringAsFixed(2)} · risk_class: ${risk.riskClass}',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.of(sheetContext).pop();
                                  _replaceWith(
                                    context,
                                    ControlRiskScreen(
                                      items: items,
                                      controlId: risk.control.id,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

List<_ControlRiskResult> _buildAllCatalogRisks(
    List<ChecklistItem> activeItems) {
  final template = buildChecklistTemplateFromCatalog();
  final activeById = <String, ChecklistItem>{
    for (final item in activeItems) item.id: item,
  };

  final merged = template.map((catalogItem) {
    final active = activeById[catalogItem.id];
    if (active == null) {
      return catalogItem;
    }

    return ChecklistItem(
      id: catalogItem.id,
      domainId: catalogItem.domainId,
      domainName: catalogItem.domainName,
      domainDescription: catalogItem.domainDescription,
      title: catalogItem.title,
      description: catalogItem.description,
      riskLevel: catalogItem.riskLevel,
      scoringModel: catalogItem.scoringModel,
      fulfilmentLevel: active.fulfilmentLevel,
      note: active.note,
      criteria: List<String>.from(catalogItem.criteria),
      anchorCriteria: <int, List<String>>{
        for (final entry in catalogItem.anchorCriteria.entries)
          entry.key: List<String>.from(entry.value),
      },
      evidence: List<ChecklistEvidence>.from(active.evidence),
    );
  }).toList(growable: false);

  final results =
      merged.map(_RiskComputation.evaluateControl).toList(growable: false);
  results.sort((a, b) => b.riskIndex.compareTo(a.riskIndex));
  return results;
}

void _replaceWith(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => page),
  );
}

_DomainStyle _styleForDomain(String domainId) {
  switch (domainId) {
    case 'A':
      return const _DomainStyle(
        accent: Color(0xFF0E7490),
        border: Color(0xFF93C5D8),
        surface: Color(0xFFF5FAFC),
      );
    case 'B':
      return const _DomainStyle(
        accent: Color(0xFFB45309),
        border: Color(0xFFF3C08E),
        surface: Color(0xFFFFFAF5),
      );
    case 'C':
      return const _DomainStyle(
        accent: Color(0xFF0F766E),
        border: Color(0xFF8AD0C8),
        surface: Color(0xFFF4FCFA),
      );
    case 'D':
      return const _DomainStyle(
        accent: Color(0xFF1D4ED8),
        border: Color(0xFFA9BCF5),
        surface: Color(0xFFF5F8FF),
      );
    case 'E':
      return const _DomainStyle(
        accent: Color(0xFF9F1239),
        border: Color(0xFFF3ADC0),
        surface: Color(0xFFFFF7FA),
      );
    default:
      return const _DomainStyle(
        accent: Color(0xFF475569),
        border: Color(0xFFCBD5E1),
        surface: Color(0xFFF8FAFC),
      );
  }
}

class _DomainStyle {
  const _DomainStyle({
    required this.accent,
    required this.border,
    required this.surface,
  });

  final Color accent;
  final Color border;
  final Color surface;
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}
