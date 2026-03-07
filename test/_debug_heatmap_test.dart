import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/app.dart';

void main() {
  testWidgets('debug home nav after starting assessment', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    await tester.tap(find.text('Jetzt starten'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Prüfung starten'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.enterText(find.byType(TextFormField).first, 'Debug Home');
    await tester.tap(find.text('Prüfung mit dieser Checkliste starten'));

    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      final ex = tester.takeException();
      if (ex != null) {
        fail('Exception after navigation: $ex');
      }
    }

    expect(find.text('Aktive Prüfung:'), findsOneWidget);
  });
}
