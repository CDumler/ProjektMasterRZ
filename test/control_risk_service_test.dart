import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/control_risk_service.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

void main() {
  const service = ControlRiskService();

  ChecklistItem buildItem({
    required bool isMandatory,
    required int criticality,
    int fulfilmentLevel = 0,
    String note = '',
    ChecklistScoringModel scoringModel = ChecklistScoringModel.conformity,
  }) {
    return ChecklistItem(
      id: 'ctrl-1',
      title: 'Control',
      description: 'Description',
      riskLevel: criticality,
      isMandatory: isMandatory,
      scoringModel: scoringModel,
      fulfilmentLevel: fulfilmentLevel,
      note: note,
    );
  }

  test('MODE_CONFORMITY: not fulfilled -> effectiveness 0, gap 1', () {
    final result = service.evaluateControl(
      buildItem(isMandatory: true, criticality: 5, fulfilmentLevel: 0),
    );

    expect(result.modeToken, 'MODE_CONFORMITY');
    expect(result.assessmentValue, 0.0);
    expect(result.effectiveness, 0.0);
    expect(result.gap, 1.0);
    expect(result.riskIndex, 5.0);
  });

  test('MODE_CONFORMITY: partially fulfilled -> effectiveness 0.5', () {
    final result = service.evaluateControl(
      buildItem(isMandatory: true, criticality: 4, fulfilmentLevel: 1),
    );

    expect(result.modeToken, 'MODE_CONFORMITY');
    expect(result.assessmentValue, 0.5);
    expect(result.effectiveness, 0.5);
    expect(result.gap, 0.5);
    expect(result.riskIndex, 2.0);
  });

  test('MODE_MATURITY: uses maturity score 0..5 with score/5 normalization',
      () {
    final result = service.evaluateControl(
      buildItem(
        isMandatory: false,
        criticality: 5,
        scoringModel: ChecklistScoringModel.maturity,
        fulfilmentLevel: 3,
      ),
    );

    expect(result.modeToken, 'MODE_MATURITY');
    expect(result.assessmentValue, 3.0);
    expect(result.effectiveness, 0.6);
    expect(result.gap, 0.4);
    expect(result.riskIndex, 2.0);
  });

  test('MODE_MATURITY: supports level-based scoring without note parsing', () {
    final result = service.evaluateControl(
      buildItem(
        isMandatory: false,
        criticality: 3,
        scoringModel: ChecklistScoringModel.maturity,
        fulfilmentLevel: 2,
      ),
    );

    expect(result.modeToken, 'MODE_MATURITY');
    expect(result.assessmentValue, 2.0);
    expect(result.effectiveness, 0.4);
    expect(result.gap, 0.6);
    expect(result.riskIndex, 1.8);
  });

  test('riskIndex remains clamped to range 0..5 and rounded', () {
    final result = service.evaluateControl(
      buildItem(
        isMandatory: false,
        criticality: 9,
        scoringModel: ChecklistScoringModel.maturity,
        fulfilmentLevel: 4,
      ),
    );

    expect(result.riskIndex, inInclusiveRange(0.0, 5.0));
    expect(result.riskIndex, 1.0);
  });

  test('maturity level labels are defined from 0 to 5', () {
    expect(maturityLevelLabel(0), 'Initial');
    expect(maturityLevelLabel(1), 'Ad-hoc');
    expect(maturityLevelLabel(2), 'Repeatable');
    expect(maturityLevelLabel(3), 'Defined');
    expect(maturityLevelLabel(4), 'Managed');
    expect(maturityLevelLabel(5), 'Optimized');
  });
}
