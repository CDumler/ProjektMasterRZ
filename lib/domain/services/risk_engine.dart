import 'package:collection/collection.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';

class RiskEngine {
  const RiskEngine();

  ScoredRisk calculate({required int likelihood, required int impact}) {
    if (likelihood < 1 || likelihood > 5) {
      throw ArgumentError.value(
          likelihood, 'likelihood', 'must be between 1 and 5');
    }
    if (impact < 1 || impact > 5) {
      throw ArgumentError.value(impact, 'impact', 'must be between 1 and 5');
    }

    final score = likelihood * impact;
    return ScoredRisk(
      likelihood: likelihood,
      impact: impact,
      score: score,
      riskClass: _classify(score),
    );
  }

  RiskClass _classify(int score) {
    if (score <= 5) {
      return RiskClass.low;
    }
    if (score <= 10) {
      return RiskClass.medium;
    }
    if (score <= 15) {
      return RiskClass.high;
    }
    return RiskClass.critical;
  }

  List<DomainRiskAggregate> aggregateByDomain(
    Map<String, List<RiskRecord>> risksByDomain,
  ) {
    return risksByDomain.entries.map((entry) {
      final values = entry.value.map((r) => r.score).toList(growable: false);
      final max = values.isEmpty ? 0 : values.max;
      final avg = values.isEmpty ? 0.0 : values.average;
      return DomainRiskAggregate(domainId: entry.key, max: max, average: avg);
    }).toList(growable: false);
  }
}
