import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/app.dart';

void main() {
  testWidgets('welcome screen shows text and start button', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    expect(find.textContaining('Willkommen zur', findRichText: true), findsOneWidget);
    expect(find.text('Jetzt starten'), findsOneWidget);
  });

  testWidgets('start button navigates to profile with admin account', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    await tester.tap(find.text('Jetzt starten'));
    await tester.pumpAndSettle();

    expect(find.text('Profil des Prüfers'), findsOneWidget);
    expect(find.text('admin@rz-checkliste.de'), findsOneWidget);
    expect(find.text('Prüfung starten'), findsOneWidget);
    expect(find.text('Zu bestehender Prüfung'), findsOneWidget);
  });

  testWidgets('profile can open existing assessment screen', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    await tester.tap(find.text('Jetzt starten'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zu bestehender Prüfung'));
    await tester.pumpAndSettle();

    expect(find.text('Bestehende Prüfungen'), findsOneWidget);
    expect(find.textContaining('Es gibt noch keine gespeicherten Prüfungen'), findsOneWidget);
  });

  testWidgets('profile can start assessment and open checklist', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    await tester.tap(find.text('Jetzt starten'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Prüfung starten'));
    await tester.pumpAndSettle();

    expect(find.text('Checkliste erstellen'), findsOneWidget);
    expect(find.text('Punkt hinzufügen'), findsOneWidget);
    expect(find.text('Punkte bearbeiten'), findsOneWidget);
    expect(find.text('Prüfungsname'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Prüfung Alpha');

    await tester.tap(find.text('Prüfung mit dieser Checkliste starten'));
    await tester.pumpAndSettle();

    expect(find.text('Aktive Prüfung:'), findsOneWidget);
    expect(find.text('Prüfung Alpha'), findsOneWidget);

    await tester.tap(find.text('Checkliste öffnen'));
    await tester.pumpAndSettle();

    expect(find.text('Checkliste'), findsOneWidget);
  });

  testWidgets('started assessment appears in existing assessments list', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    await tester.tap(find.text('Jetzt starten'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Prüfung starten'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Prüfung Beta');
    await tester.tap(find.text('Prüfung mit dieser Checkliste starten'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zum Profil zurück'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zu bestehender Prüfung'));
    await tester.pumpAndSettle();

    expect(find.text('Bestehende Prüfungen'), findsOneWidget);
    expect(find.text('Prüfung Beta'), findsOneWidget);
  });

  testWidgets('logout from profile navigates to login', (tester) async {
    await tester.pumpWidget(const DatacenterApp());

    await tester.tap(find.text('Jetzt starten'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Abmelden'));
    await tester.pumpAndSettle();

    expect(find.text('Anmeldung'), findsOneWidget);
    expect(find.text('Hier Konto erstellen'), findsOneWidget);
  });
}
