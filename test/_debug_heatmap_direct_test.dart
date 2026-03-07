import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/data/checklist_catalog.dart';
import 'package:rz_checkliste_risikoanalyse/screens/home_screen.dart';

void main() {
  testWidgets('direct home screen loads', (tester) async {
    final items = buildChecklistTemplateFromCatalog();
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          onOpenChecklist: () {},
          onOpenRiskAnalysis: () {},
          onBackToProfile: () {},
          items: items,
          assessmentName: 'Test',
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 16));
    expect(find.text('Kritikalitäts-Stand'), findsOneWidget);
  });
}
