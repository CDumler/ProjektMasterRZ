# my_datacenter_app

Flutter-App fuer eine toolgestuetzte Checkliste und Risikoanalyse von Rechenzentren.

## Ziel
Die App bietet drei Kernbereiche:
- `Home`: Einstieg und Navigation
- `Checkliste`: Bewertung einzelner Pruefpunkte (erfuellt / nicht erfuellt)
- `Risikoanalyse`: Aggregation und Visualisierung der Risiken

## Architektur (vereinfacht, wartbar)
Die App folgt Separation of Concerns:
- UI-Layer: Screens + Widgets
- Domain-Modell: `ChecklistItem`
- Utility-Layer: Risiko-Helferfunktionen

Navigation erfolgt bewusst schlank ueber `Navigator.push()`.
State Management ist lokal im App-State umgesetzt und fuer den aktuellen Umfang ausreichend.

## Projektstruktur
```text
lib/
├── main.dart
├── app.dart
├── models/
│   └── checklist_item.dart
├── screens/
│   ├── home_screen.dart
│   ├── checklist_screen.dart
│   └── risk_analysis_screen.dart
├── widgets/
│   ├── checklist_tile.dart
│   └── risk_badge.dart
└── utils/
    └── risk_utils.dart
```

## Datenmodell
`ChecklistItem` enthaelt:
- `id`
- `title`
- `description`
- `isFulfilled`
- `riskLevel` (1-5)

## Risikoaggregation
Im Risikoanalyse-Screen wird der durchschnittliche Risiko-Wert berechnet:
- Summe aller `riskLevel`
- geteilt durch Anzahl der Eintraege

Zusatzanzeige:
- offene Punkte (nicht erfuellt)
- Einzelrisiken pro Pruefpunkt

## Build & Run
```bash
flutter pub get
flutter run -d "iPhone 16e"
```

Alternativ mit Device-ID:
```bash
flutter run -d D6C796C4-C85A-4544-A51A-9D92FAEFC795
```

## Tests
Widget-Test:
```bash
flutter test test/widget_test.dart
```

Statische Analyse:
```bash
flutter analyze
```

Hinweis: Im Repository liegen zusaetzliche Altmodule aus der vorherigen Version (`lib/presentation`, `lib/domain`, `lib/data`).
Der aktuelle App-Flow nutzt fuer den gewuenschten Aufbau ausschliesslich:
- `lib/app.dart`
- `lib/models/*`
- `lib/screens/*`
- `lib/widgets/*`
- `lib/utils/*`
