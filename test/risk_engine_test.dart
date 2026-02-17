import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/risk_engine.dart';

void main() {
  group('RiskEngine', () {
    const engine = RiskEngine();

    test('calculates deterministic score and class', () {
      final r = engine.calculate(likelihood: 4, impact: 4);
      expect(r.score, 16);
      expect(r.riskClass, RiskClass.critical);
    });

    test('aggregates by domain max and avg', () {
      final now = DateTime.now();
      final data = {
        'd1': [
          RiskRecord(
            id: 'r1',
            assessmentId: 'a1',
            findingId: 'f1',
            likelihood: 2,
            impact: 2,
            score: 4,
            riskClass: RiskClass.low,
            rationale: '',
            createdAt: now,
            updatedAt: now,
          ),
          RiskRecord(
            id: 'r2',
            assessmentId: 'a1',
            findingId: 'f2',
            likelihood: 5,
            impact: 3,
            score: 15,
            riskClass: RiskClass.high,
            rationale: '',
            createdAt: now,
            updatedAt: now,
          ),
        ]
      };

      final agg = engine.aggregateByDomain(data).first;
      expect(agg.max, 15);
      expect(agg.average, 9.5);
    });
  });
}
