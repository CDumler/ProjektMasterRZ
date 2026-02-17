import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/finding_derivation_service.dart';

void main() {
  group('FindingDerivationService', () {
    const service = FindingDerivationService(maturityThreshold: 3);

    final item = ControlItem(
      id: 'ci-1',
      domainId: 'd',
      topicId: 't',
      title: 'Title',
      objective: 'Obj',
      question: 'Q',
      scoringModel: ScoringModel.fulfilment,
      anchorsJson: '{}',
      evidenceRequirementsJson: '{}',
      riskRelevant: true,
      catalogVersion: 'v1',
      isActive: true,
    );

    test('creates finding for partial fulfilment', () {
      final answer = ItemAnswer(
        id: 'a1',
        assessmentId: 'asm',
        controlItemId: 'ci-1',
        scoreType: ScoringModel.fulfilment,
        fulfilmentEnum: Fulfilment.partial,
        notes: '',
        answeredBy: 'u',
        answeredAt: DateTime.now(),
      );

      expect(service.shouldCreateFinding(item, answer), isTrue);
      expect(service.deriveType(answer, evidenceValid: false), FindingType.missingEvidence);
      expect(service.deriveSeverity(answer), Severity.medium);
    });

    test('does not create finding for high maturity', () {
      final maturityItem = ControlItem(
        id: 'ci-2',
        domainId: 'd',
        topicId: 't',
        title: 'Title',
        objective: 'Obj',
        question: 'Q',
        scoringModel: ScoringModel.maturity,
        anchorsJson: '{}',
        evidenceRequirementsJson: '{}',
        riskRelevant: true,
        catalogVersion: 'v1',
        isActive: true,
      );

      final answer = ItemAnswer(
        id: 'a2',
        assessmentId: 'asm',
        controlItemId: 'ci-2',
        scoreType: ScoringModel.maturity,
        maturityLevel: 4,
        notes: '',
        answeredBy: 'u',
        answeredAt: DateTime.now(),
      );

      expect(service.shouldCreateFinding(maturityItem, answer), isFalse);
    });
  });
}
