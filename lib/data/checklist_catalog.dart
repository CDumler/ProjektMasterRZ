import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class ChecklistDomain {
  const ChecklistDomain({
    required this.domainId,
    required this.name,
    required this.description,
  });

  final String domainId;
  final String name;
  final String description;
}

class ChecklistControl {
  const ChecklistControl({
    required this.controlId,
    required this.domainId,
    required this.title,
    required this.description,
    required this.criticality,
    this.scoringModel = ChecklistScoringModel.conformity,
  });

  final String controlId;
  final String domainId;
  final String title;
  final String description;
  final int criticality;
  final ChecklistScoringModel scoringModel;
}

class ChecklistCriterion {
  const ChecklistCriterion({
    required this.criteriaId,
    required this.controlId,
    required this.text,
  });

  final String criteriaId;
  final String controlId;
  final String text;
}

const List<ChecklistDomain> domains = <ChecklistDomain>[
  ChecklistDomain(
    domainId: 'A',
    name: 'Technische Infrastruktur',
    description:
        'Bewertung der technischen Basis des Rechenzentrums (Stromversorgung, Kühlung, Brandschutz und Gebäudetechnik).',
  ),
  ChecklistDomain(
    domainId: 'B',
    name: 'Physische Sicherheit',
    description:
        'Bewertung der physischen Schutzmaßnahmen des Rechenzentrums (Zutritt, Perimeter, Überwachung und Besucherprozesse).',
  ),
  ChecklistDomain(
    domainId: 'C',
    name: 'Betrieb und Monitoring',
    description:
        'Bewertung der Betriebsprozesse des Rechenzentrums (Monitoring, Incident Management und Change Management).',
  ),
  ChecklistDomain(
    domainId: 'D',
    name: 'Netzwerk und Connectivity',
    description:
        'Bewertung der Netzwerkarchitektur, Redundanz und externen Anbindungen des Rechenzentrums.',
  ),
  ChecklistDomain(
    domainId: 'E',
    name: 'Notfall und Kontinuität',
    description:
        'Bewertung von Notfall- und Wiederherstellungsmaßnahmen für kritische IT-Services.',
  ),
];

const List<ChecklistControl> controls = <ChecklistControl>[
  ChecklistControl(
    controlId: 'A-CTRL-01',
    domainId: 'A',
    title: 'Redundante Stromversorgung',
    description:
        'Stromversorgungsarchitektur ohne Single Points of Failure für kritische IT-Lasten.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-02',
    domainId: 'A',
    title: 'USV-Kapazität und Autonomie',
    description:
        'Sicherstellung ausreichender USV-Leistung und definierter Überbrückungszeit.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-03',
    domainId: 'A',
    title: 'Notstromversorgung',
    description:
        'Versorgung kritischer IT-Lasten durch Generatoren bei Netzausfall.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-04',
    domainId: 'A',
    title: 'Energie-Failover-Tests',
    description:
        'Regelmäßige Tests der Umschalt- und Failover-Mechanismen der Energieversorgung.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-05',
    domainId: 'A',
    title: 'Redundante Kühlung',
    description:
        'Kühlarchitektur toleriert Ausfall einzelner Komponenten ohne kritische Temperaturüberschreitung.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-06',
    domainId: 'A',
    title: 'Luftführungskonzept',
    description:
        'Strukturierte Luftführung zur Vermeidung von Hotspots und Luftvermischung.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-07',
    domainId: 'A',
    title: 'Kühlkapazitätsplanung',
    description:
        'Dokumentierte Kühlkapazität und regelmäßige Überprüfung der Auslegungsannahmen.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-08',
    domainId: 'A',
    title: 'Branddetektion',
    description: 'Frühzeitige Branddetektion in allen kritischen IT-Bereichen.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-09',
    domainId: 'A',
    title: 'Löschsysteme',
    description:
        'IT-geeignete, zonierte Löschsysteme mit kontrollierten Auslösemechanismen.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-10',
    domainId: 'A',
    title: 'Wartung Brandschutzsysteme',
    description:
        'Regelmäßige Wartung und Prüfung von Branddetektion und Löschanlagen.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-11',
    domainId: 'A',
    title: 'Schutz vor Wasserschäden',
    description: 'Minimierung von Wasser- und Leckagerisiken im IT-Bereich.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-12',
    domainId: 'A',
    title: 'Bauliche Infrastruktur',
    description:
        'Bauliche Ausführung unterstützt sicheren und stabilen IT-Betrieb.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-13',
    domainId: 'A',
    title: 'Gebäudetechnische Risiken',
    description:
        'Bewertung und Absicherung gebäudetechnischer Schnittstellen zum IT-Bereich.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-14',
    domainId: 'A',
    title: 'Verantwortlichkeiten Elektrobetrieb',
    description:
        'Verantwortlichkeiten und Qualifikationsanforderungen für Betrieb und Arbeiten an elektrotechnischen Anlagen im Rechenzentrum müssen festgelegt sein.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-15',
    domainId: 'A',
    title: 'Prüfungen elektrischer Anlagen',
    description:
        'Wiederkehrende Prüfungen und Wartungen sicherheitskritischer elektrischer Anlagen müssen fristgerecht gemäß definiertem Prüfregime erfolgen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-16',
    domainId: 'A',
    title: 'Sicherheitsverfahren Elektrotechnik',
    description:
        'Für sicherheitskritische Arbeiten an elektrischen Anlagen muss ein verbindliches Sicherheitsverfahren angewendet werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-17',
    domainId: 'A',
    title: 'Umgebungsparameter',
    description:
        'Definition und Überwachung relevanter Umgebungsparameter im IT-Bereich.',
    criticality: 2,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-01',
    domainId: 'B',
    title: 'Zutrittskontrolle',
    description:
        'Zugang zu Rechenzentrumszonen ausschließlich über autorisierte Berechtigungen.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-02',
    domainId: 'B',
    title: 'Zutrittsauthentisierung',
    description:
        'Authentisierung entsprechend dem Schutzbedarf der jeweiligen Zone.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-03',
    domainId: 'B',
    title: 'Zutrittsrechte-Lifecycle',
    description:
        'Verwaltung von Zutrittsrechten über ihren gesamten Lebenszyklus.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-04',
    domainId: 'B',
    title: 'Perimeterschutz',
    description:
        'Der Standortperimeter muss als abgestufte Zonenstruktur umgesetzt sein, die Annäherung und Zutritt schrittweise kontrolliert.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-05',
    domainId: 'B',
    title: 'Gesicherte Gebäudezugänge',
    description:
        'Perimeter- und Gebäudezugänge müssen baulich und technisch so ausgelegt sein, dass Umgehungs- und Eindringszenarien erschwert werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-06',
    domainId: 'B',
    title: 'Gesicherte Anlieferung',
    description:
        'Anlieferung, Ladezonen und Nebenzugänge müssen in die Sicherheitszonierung eingebunden und entsprechend abgesichert sein.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-07',
    domainId: 'B',
    title: 'Videoüberwachung',
    description:
        'Überwachung kritischer Bereiche zur Detektion sicherheitsrelevanter Ereignisse.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-08',
    domainId: 'B',
    title: 'Schutz von Videodaten',
    description:
        'Zugriff und Betrieb der Video- und Sensordaten müssen so geregelt sein, dass Missbrauch verhindert und die Integrität der Daten gewahrt bleibt.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-09',
    domainId: 'B',
    title: 'Regelkonforme Videodaten',
    description:
        'Erhebung, Speicherung und Löschung von Video- und Sensordaten müssen zweckgebunden und regelkonform erfolgen.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-10',
    domainId: 'B',
    title: 'Besucher- und Fremdfirmenprozesse',
    description:
        'Kontrolle und Dokumentation von Besuchern und externen Dienstleistern.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-11',
    domainId: 'B',
    title: 'Sicherheitsregeln Fremdfirmen',
    description:
        'Tätigkeiten von Fremdfirmen im Rechenzentrum müssen nach definierten Sicherheitsregeln erfolgen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-12',
    domainId: 'B',
    title: 'Kontrollierte Vor-Ort-Arbeiten',
    description:
        'Vor-Ort-Arbeiten wie Wartung, Lieferung oder Entsorgung müssen so organisiert sein, dass Manipulation, Diebstahl und unbeabsichtigte Störungen minimiert werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-13',
    domainId: 'B',
    title: 'Rack- und Cage-Sicherung',
    description:
        'Racks, Cages und sicherheitskritische Bereiche müssen entsprechend der Zonierung physisch gesichert sein.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-14',
    domainId: 'B',
    title: 'Schlüsselverwaltung',
    description:
        'Schlüssel und Schließmedien müssen über ihren Lebenszyklus kontrolliert verwaltet werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-15',
    domainId: 'B',
    title: 'Tailgating-Schutz',
    description:
        'Zutritt in hochkritische Zonen muss so gestaltet sein, dass unberechtigtes Mitgehen wirksam verhindert oder erkannt wird.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-01',
    domainId: 'C',
    title: 'Infrastrukturmonitoring',
    description:
        'Zentrale Überwachung kritischer Infrastruktur- und Betriebsparameter.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-02',
    domainId: 'C',
    title: 'Alarmmanagement',
    description:
        'Definierte Alarmregeln, Schwellwerte und Eskalationsmechanismen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-03',
    domainId: 'C',
    title: 'Alarmeskalation',
    description:
        'Alarmierung und Eskalation müssen rollenbasiert und zeitnah bis zur definierten Reaktions- bzw. Lösungsverantwortung erfolgen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-04',
    domainId: 'C',
    title: 'Incident Management',
    description: 'Strukturierte Behandlung und Nachverfolgung von Störungen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-05',
    domainId: 'C',
    title: 'Change Management',
    description: 'Kontrollierte Planung und Umsetzung technischer Änderungen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-06',
    domainId: 'C',
    title: 'Wartungssteuerung',
    description:
        'Wartungstätigkeiten müssen geplant, koordiniert und so gesteuert werden, dass unbeabsichtigte Betriebsunterbrechungen minimiert werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-07',
    domainId: 'C',
    title: 'Kapazitätsüberwachung',
    description:
        'Kapazitäten für Leistung, Kühlung und Stellfläche müssen definiert und fortlaufend gegen die tatsächliche Nutzung bewertet werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-08',
    domainId: 'C',
    title: 'Kapazitätsgrenzen und Reserven',
    description:
        'Kapazitätsgrenzen und Reserven müssen festgelegt sein, sodass Überbelegung und riskante Auslastungsspitzen vermieden werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-09',
    domainId: 'C',
    title: 'Kapazitätsplanung',
    description:
        'Kapazitätsplanung muss erwartetes Wachstum und größere Änderungen berücksichtigen, sodass erforderliche Maßnahmen rechtzeitig eingeleitet werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-10',
    domainId: 'C',
    title: 'Betriebsdokumentation',
    description:
        'Betriebsdokumentation muss aktuell, versioniert und für relevante Rollen verfügbar sein.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-11',
    domainId: 'C',
    title: 'Bestands- und Konfigurationsdaten',
    description:
        'Konfigurations- und Bestandsinformationen zu kritischen Komponenten und Betriebsobjekten müssen konsistent gepflegt werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-12',
    domainId: 'C',
    title: 'Betriebskennzahlen',
    description:
        'Betriebskennzahlen müssen definiert sein und Stabilität, Reaktionsfähigkeit sowie Prozessqualität abdecken.',
    criticality: 2,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-13',
    domainId: 'C',
    title: 'KPI-Auswertung',
    description:
        'Kennzahlen müssen regelmäßig ausgewertet werden und zu konkreten Verbesserungsmaßnahmen mit Verantwortlichkeiten und Nachverfolgung führen.',
    criticality: 2,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-14',
    domainId: 'C',
    title: 'Lieferantensteuerung',
    description:
        'Lieferantenleistungen für kritische Komponenten und Services müssen über klare Leistungs- und Reaktionsanforderungen gesteuert werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-15',
    domainId: 'C',
    title: 'Lieferanteneinsätze im Betrieb',
    description:
        'Lieferantenzugriffe und Vor-Ort-Leistungen müssen in den Betriebsablauf integriert und organisatorisch kontrolliert werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-16',
    domainId: 'C',
    title: 'Service-Review',
    description:
        'Servicequalität und Vertragserfüllung müssen regelmäßig überprüft und bei Abweichungen konsequent adressiert werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-17',
    domainId: 'C',
    title: 'Patch- und Firmware-Management',
    description:
        'Für RZ-relevante Systeme und Komponenten muss ein geregeltes Patch- und Firmware-Management etabliert sein.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-01',
    domainId: 'D',
    title: 'WAN-Redundanz',
    description:
        'Redundante externe Netzwerkanbindungen über unabhängige Provider.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-02',
    domainId: 'D',
    title: 'Routing-Failover',
    description:
        'Umschaltung und Routing-Failover müssen so umgesetzt sein, dass bei Ausfällen definierte Verfügbarkeits- und Latenzanforderungen eingehalten werden.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-03',
    domainId: 'D',
    title: 'Provider- und Trassendiversität',
    description:
        'Provider- und Trassenabhängigkeiten müssen so gestaltet sein, dass gemeinsame Ausfallursachen minimiert werden.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-04',
    domainId: 'D',
    title: 'Redundante Netzwerktopologie',
    description:
        'Redundante Netzwerkkomponenten und Pfade ohne Single Points of Failure.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-05',
    domainId: 'D',
    title: 'Netzwerk-Failover',
    description:
        'Redundanz- und Failover-Mechanismen müssen definierte Ausfallszenarien ohne ungeplanten Serviceabbruch beherrschen.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-06',
    domainId: 'D',
    title: 'Netzwerktopologie-Dokumentation',
    description:
        'Netzwerktopologie und Redundanzkonzept müssen konsistent dokumentiert und bei wesentlichen Änderungen aktualisiert werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-07',
    domainId: 'D',
    title: 'Netzwerksegmentierung',
    description: 'Segmentierung und Absicherung von Netzwerkzonen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-08',
    domainId: 'D',
    title: 'Zonengrenzen absichern',
    description:
        'Übergänge zwischen Zonen müssen technisch abgesichert sein und dem Prinzip folgen, nur notwendige Kommunikation zuzulassen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-09',
    domainId: 'D',
    title: 'Administrativer Netzwerkzugriff',
    description:
        'Administrativer Zugriff auf Netzwerkkomponenten muss geschützt und klar vom produktiven Datenverkehr getrennt geführt werden.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-10',
    domainId: 'D',
    title: 'Cross-Connect-Verwaltung',
    description:
        'Cross-Connects und Carrier-Übergänge müssen eindeutig definiert, konsistent gekennzeichnet und end-to-end verwaltet werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-11',
    domainId: 'D',
    title: 'Änderungen an Carrier-Strukturen',
    description:
        'Änderungen an Carrier- und Cross-Connect-Strukturen müssen kontrolliert erfolgen, um Fehlpatching und unbeabsichtigte Unterbrechungen zu minimieren.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-12',
    domainId: 'D',
    title: 'Wegediversität bei Änderungen',
    description:
        'Trassen- und Wegediversität sowie Abhängigkeiten müssen bei relevanten Änderungen berücksichtigt werden, um gemeinsame Ausfallursachen zu vermeiden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-13',
    domainId: 'D',
    title: 'Out-of-Band-Management',
    description:
        'Out-of-Band-Management muss als unabhängiger Zugriffspfad ausgelegt sein, der auch bei Störungen des Produktionsnetzes administrative Maßnahmen ermöglicht.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-14',
    domainId: 'D',
    title: 'Absicherung OOB-Zugänge',
    description:
        'Out-of-Band-Zugänge müssen stark abgesichert und auf berechtigte Zwecke sowie Personen begrenzt sein.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-15',
    domainId: 'D',
    title: 'Break-Glass-Zugriffe',
    description:
        'Notfallzugriffe müssen geregelt sein, um in Ausnahmesituationen handlungsfähig zu bleiben, ohne Sicherheitsanforderungen zu unterlaufen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-16',
    domainId: 'D',
    title: 'Netzwerk-Backup und Restore',
    description:
        'Konfigurationen kritischer Netzwerkkomponenten müssen gesichert sein und eine kontrollierte Wiederherstellung muss möglich sein.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-01',
    domainId: 'E',
    title: 'BCM Governance',
    description:
        'Klare Verantwortlichkeiten und organisatorische Struktur für Business Continuity.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-02',
    domainId: 'E',
    title: 'Notfallorganisation',
    description:
        'Eine Notfallorganisation mit definierten Rollen und Vertretungen muss eingerichtet sein, die Handlungsfähigkeit für kritische Szenarien sicherstellt.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-03',
    domainId: 'E',
    title: 'BCM-Prozesse',
    description:
        'BCM-Prozesse für Auslösung, Lagebewertung und Übergang in den Notbetrieb müssen definiert und mit relevanten Schnittstellen abgestimmt sein.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-04',
    domainId: 'E',
    title: 'Disaster-Recovery-Strategie',
    description:
        'Definierte Strategie zur Wiederherstellung kritischer IT-Services.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-05',
    domainId: 'E',
    title: 'DR-Fähigkeit',
    description:
        'DR-Fähigkeiten müssen so ausgeprägt sein, dass die definierten Wiederherstellungsziele für kritische Services erreicht werden können.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-06',
    domainId: 'E',
    title: 'Disaster-Recovery-Tests',
    description:
        'Regelmäßige Tests der Wiederherstellungs- und Failover-Fähigkeiten.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-07',
    domainId: 'E',
    title: 'RTO/RPO-Definition',
    description:
        'RTO- und RPO-Ziele müssen für kritische Services oder Servicegruppen definiert und priorisiert sein.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-08',
    domainId: 'E',
    title: 'RTO/RPO-Abstimmung',
    description:
        'RTO/RPO-Ziele müssen mit relevanten Abhängigkeiten abgestimmt sein und ein umsetzbares Gesamtzielbild ergeben.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-09',
    domainId: 'E',
    title: 'Wiederanlauf- und Notbetriebspläne',
    description:
        'Wiederanlauf- und Notbetriebspläne müssen für relevante Szenarien vorhanden sein und kritische RZ-Betriebsfunktionen abdecken.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-10',
    domainId: 'E',
    title: 'Wiederherstellungsabläufe',
    description:
        'Pläne müssen klare Abläufe, Rollen, Reihenfolgen, Abhängigkeiten und Übergangskriterien für die kontrollierte Wiederherstellung festlegen.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-11',
    domainId: 'E',
    title: 'Pflege der Wiederanlaufpläne',
    description:
        'Pläne müssen versioniert gepflegt und bei wesentlichen technischen oder organisatorischen Änderungen aktualisiert werden.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-12',
    domainId: 'E',
    title: 'Eskalationsprozesse',
    description:
        'Eskalationskriterien und Eskalationswege müssen definiert sein, sodass relevante Ereignisse zeitnah auf das richtige Entscheidungsniveau gehoben werden.',
    criticality: 4,
    scoringModel: ChecklistScoringModel.conformity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-13',
    domainId: 'E',
    title: 'Krisenkommunikation',
    description:
        'Kommunikationsprozesse für Krisensituationen müssen definiert sein und interne sowie externe Kommunikation strukturiert steuern.',
    criticality: 3,
    scoringModel: ChecklistScoringModel.maturity,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-14',
    domainId: 'E',
    title: 'Backup- und Restore-Fähigkeit',
    description:
        'Backup- und Wiederherstellungsfähigkeit muss so organisiert sein, dass definierte RPO-Ziele unterstützt werden.',
    criticality: 5,
    scoringModel: ChecklistScoringModel.conformity,
  ),
];

const Map<String, Map<int, List<String>>> controlAnchorCriteria =
    <String, Map<int, List<String>>>{
  'A-CTRL-01': <int, List<String>>{
    2: <String>[
      'Redundanzniveau ist durchgängig umgesetzt; keine relevanten Single Points of Failure für kritische Lasten.',
    ],
    1: <String>[
      'Redundanz teilweise umgesetzt; einzelne relevante Single Points of Failure/Abhängigkeiten bestehen.',
    ],
    0: <String>[
      'Redundanzniveau nicht umgesetzt; relevante Single Points of Failure vorhanden.',
    ],
  },
  'A-CTRL-02': <int, List<String>>{
    2: <String>[
      'Leistung und Autonomie erfüllen die festgelegten Anforderungen für die kritische Last.',
    ],
    1: <String>[
      'Anforderungen sind definiert, aber Leistung oder Autonomie sind nicht durchgängig ausreichend.',
    ],
    0: <String>[
      'Keine definierten Anforderungen oder USV erfüllt sie nicht.',
    ],
  },
  'A-CTRL-03': <int, List<String>>{
    2: <String>[
      'Notstrom kann kritische Last über definierte Dauer tragen (inkl. Umschaltung).',
    ],
    1: <String>[
      'Notstrom grundsätzlich vorhanden, aber Dauer/Lastdeckung/Umschaltung nicht vollständig ausreichend.',
    ],
    0: <String>[
      'Notstromfähigkeit für kritische Last nicht gegeben.',
    ],
  },
  'A-CTRL-04': <int, List<String>>{
    0: <String>[
      'Keine geplanten Umschalt-/Failover-Tests.',
    ],
    1: <String>[
      'Tests ad-hoc, abhängig von Einzelpersonen.',
    ],
    2: <String>[
      'Wiederkehrende Tests, aber ohne standardisierte Planung/Auswertung.',
    ],
    3: <String>[
      'Definierter Testplan (Umfang, Intervalle, Rollen) und konsistente Durchführung.',
    ],
    4: <String>[
      'Gemanagt (Abweichungsmanagement, Trend/Wirksamkeitsreview, definierte Korrekturmaßnahmen).',
    ],
    5: <String>[
      'Optimiert (Simulationen/Übungen, kontinuierliche Verbesserung, hohe Testqualität).',
    ],
  },
  'A-CTRL-05': <int, List<String>>{
    2: <String>[
      'Redundanzniveau deckt relevante Einzelfehler ab; kritische Temperaturgrenzen bleiben eingehalten.',
    ],
    1: <String>[
      'Redundanz oder Ausfalltoleranz nur für Teilbereiche/Lastfälle.',
    ],
    0: <String>[
      'Keine ausreichende Ausfalltoleranz/Redundanz.',
    ],
  },
  'A-CTRL-06': <int, List<String>>{
    2: <String>[
      'Layout/Containment/Luftführung konsistent umgesetzt; Hotspot-Risiken strukturell minimiert.',
    ],
    1: <String>[
      'Konzept vorhanden, aber nicht durchgängig umgesetzt (Lücken/Inkonsistenzen).',
    ],
    0: <String>[
      'Kein wirksames Luftführungskonzept.',
    ],
  },
  'A-CTRL-07': <int, List<String>>{
    0: <String>[
      'Keine definierten Auslegungsannahmen/Kapazitätsbasis.',
    ],
    1: <String>[
      'Annahmen informell, Prüfung nur reaktiv.',
    ],
    2: <String>[
      'Wiederholbare Prüfung, aber ohne klaren Trigger/Prozess.',
    ],
    3: <String>[
      'Definierter Prozess für Annahmen und Änderungsprüfung (Trigger, Rollen, Ergebnis).',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Reviews, Kapazitäts-/Laständerungen gesteuert).',
    ],
    5: <String>[
      'Optimiert (Szenario-Planung, kontinuierliche Verbesserung, hohe Prognosequalität).',
    ],
  },
  'A-CTRL-08': <int, List<String>>{
    2: <String>[
      'Abdeckung umfasst alle kritischen Zonen (inkl. relevanter Hohlräume, falls vorhanden).',
    ],
    1: <String>[
      'Abdeckung in Teilbereichen lückenhaft oder nicht zonenkonsistent.',
    ],
    0: <String>[
      'Abdeckung unzureichend oder nicht vorhanden.',
    ],
  },
  'A-CTRL-09': <int, List<String>>{
    2: <String>[
      'Eignung, Zonierung und Auslösemechanismen sind vollständig umgesetzt.',
    ],
    1: <String>[
      'System vorhanden, aber Zonierung/Auslösemechanismen/Eignung nur teilweise passend.',
    ],
    0: <String>[
      'Kein geeignetes, zoniertes Löschsystem oder fehlende kontrollierte Auslösung.',
    ],
  },
  'A-CTRL-10': <int, List<String>>{
    0: <String>[
      'Kein geregelter Betrieb/Instandhaltung.',
    ],
    1: <String>[
      'Instandhaltung ad-hoc.',
    ],
    2: <String>[
      'Wiederkehrend, aber ohne Standards/Qualitätssicherung.',
    ],
    3: <String>[
      'Definiertes Instandhaltungskonzept (Intervalle, Rollen, Prüfumfang) und umgesetzt.',
    ],
    4: <String>[
      'Gemanagt (Abweichungen/Mängelsteuerung, regelmäßige Wirksamkeitsreviews).',
    ],
    5: <String>[
      'Optimiert (kontinuierliche Verbesserung, hohe Verfügbarkeit, Lessons Learned).',
    ],
  },
  'A-CTRL-11': <int, List<String>>{
    2: <String>[
      'Schutzmaßnahmen sind vollständig und risikogerecht umgesetzt.',
    ],
    1: <String>[
      'Schutzmaßnahmen nur in Teilbereichen/mit Lücken umgesetzt.',
    ],
    0: <String>[
      'Keine oder unzureichende Maßnahmen.',
    ],
  },
  'A-CTRL-12': <int, List<String>>{
    2: <String>[
      'Bauliche Ausführung unterstützt Betrieb; relevante Ausfallrisiken sind minimiert.',
    ],
    1: <String>[
      'Bauliche Ausführung teilweise geeignet; relevante Schwachstellen bestehen.',
    ],
    0: <String>[
      'Bauliche Ausführung ist nicht geeignet/erhöht Ausfallrisiken.',
    ],
  },
  'A-CTRL-13': <int, List<String>>{
    2: <String>[
      'Relevante Schnittstellen sind identifiziert, bewertet und abgesichert.',
    ],
    1: <String>[
      'Bewertung/Absicherung nur für Teilmenge relevanter Schnittstellen.',
    ],
    0: <String>[
      'Keine strukturierte Bewertung/Absicherung.',
    ],
  },
  'A-CTRL-14': <int, List<String>>{
    2: <String>[
      'Verantwortlichkeiten und Qualifikationen sind klar festgelegt und gelten für relevante Tätigkeiten.',
    ],
    1: <String>[
      'Festlegungen existieren, aber lückenhaft/unklar (z. B. Vertretung, Fremdfirmen, Tätigkeitsumfang).',
    ],
    0: <String>[
      'Keine klare Festlegung.',
    ],
  },
  'A-CTRL-15': <int, List<String>>{
    0: <String>[
      'Kein Prüfregime / keine wiederkehrenden Prüfungen.',
    ],
    1: <String>[
      'Prüfungen ad-hoc, Fristen ungeführt.',
    ],
    2: <String>[
      'Wiederkehrend, aber ohne konsistente Steuerung/Transparenz.',
    ],
    3: <String>[
      'Prüfregime definiert (Intervalle, Umfang, Rollen) und fristgerecht umgesetzt.',
    ],
    4: <String>[
      'Gemanagt (Mängelsteuerung, Qualitätsreview, Ausnahmeregeln kontrolliert).',
    ],
    5: <String>[
      'Optimiert (kontinuierliche Verbesserung, hohe Termintreue, risikobasierte Optimierung).',
    ],
  },
  'A-CTRL-16': <int, List<String>>{
    0: <String>[
      'Kein definiertes Sicherheitsverfahren.',
    ],
    1: <String>[
      'Verfahren informell, uneinheitlich angewendet.',
    ],
    2: <String>[
      'Wiederholbar angewendet, aber ohne Standardisierung/Schulung.',
    ],
    3: <String>[
      'Definiertes Verfahren (Ablauf, Rollen, Freigaben) und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Unterweisungen, Kontrollen/Audits, Abweichungsbehandlung).',
    ],
    5: <String>[
      'Optimiert (kontinuierliche Verbesserung, sehr hohe Compliance, Lessons Learned).',
    ],
  },
  'A-CTRL-17': <int, List<String>>{
    2: <String>[
      'Ziel-/Grenzwerte sind festgelegt und gelten verbindlich für relevante Bereiche/Zonen.',
    ],
    1: <String>[
      'Werte sind festgelegt, aber unvollständig (z. B. nur Temperatur, nicht Feuchte) oder nicht zonenkonsistent.',
    ],
    0: <String>[
      'Keine festgelegten Ziel-/Grenzwerte.',
    ],
  },
  'B-CTRL-01': <int, List<String>>{
    2: <String>[
      'Zonen sind definiert und Zutritt ist an formalisierte Berechtigungen gebunden; keine „Generalschlüssel“-Berechtigungen ohne Begründung.',
    ],
    1: <String>[
      'Berechtigungslogik existiert, ist aber lückenhaft (z. B. einzelne Zonen/Wege nicht abgedeckt oder zu breite Berechtigungen).',
    ],
    0: <String>[
      'Zutritte erfolgen ohne definierte Berechtigungsbasis.',
    ],
  },
  'B-CTRL-02': <int, List<String>>{
    2: <String>[
      'Authentisierungsniveau ist je Zone festgelegt und umgesetzt (inkl. höheres Niveau für Hochsicherheitszonen).',
    ],
    1: <String>[
      'Authentisierung ist teilweise zonengerecht, aber inkonsistent oder mit Ausnahmen ohne klare Regel.',
    ],
    0: <String>[
      'Kein zonenabhängiges Authentisierungskonzept.',
    ],
  },
  'B-CTRL-03': <int, List<String>>{
    0: <String>[
      'Kein geregelter Lebenszyklus (Joiner/Mover/Leaver) für Zutrittsrechte.',
    ],
    1: <String>[
      'Ad-hoc-Vergabe/Entzug, personenabhängig.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards (z. B. keine einheitlichen Freigaben/Fristen).',
    ],
    3: <String>[
      'Definierter Prozess inkl. Rollen/Freigaben/Fristen und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Reviews, Ausnahmen gesteuert, KPIs/Qualitätskontrolle).',
    ],
    5: <String>[
      'Optimiert (Automatisierung über IAM/HR, kontinuierliche Verbesserung, sehr geringe Altberechtigungen).',
    ],
  },
  'B-CTRL-04': <int, List<String>>{
    2: <String>[
      'Mehrstufige Zonierung (außen→innen) ist umgesetzt und kontrolliert.',
    ],
    1: <String>[
      'Zonierung vorhanden, aber nicht durchgängig oder mit ungeschützten Übergängen.',
    ],
    0: <String>[
      'Keine abgestufte Zonierung.',
    ],
  },
  'B-CTRL-05': <int, List<String>>{
    2: <String>[
      'Zugangspunkte sind gesichert; typische Umgehungen sind durch Design/Technik adressiert.',
    ],
    1: <String>[
      'Schutz vorhanden, aber einzelne relevante Zugangspunkte/Schwachstellen bestehen.',
    ],
    0: <String>[
      'Zugangspunkte sind unzureichend gesichert.',
    ],
  },
  'B-CTRL-06': <int, List<String>>{
    2: <String>[
      'Liefer-/Nebenzugänge sind zonenkonform gesichert und kontrolliert.',
    ],
    1: <String>[
      'Einzelne Nebenzugänge/Ladezonen sind nicht gleichwertig abgesichert.',
    ],
    0: <String>[
      'Liefer-/Nebenzugänge sind unzureichend eingebunden.',
    ],
  },
  'B-CTRL-07': <int, List<String>>{
    2: <String>[
      'Abdeckung kritischer Bereiche ist vollständig und zweckgerecht.',
    ],
    1: <String>[
      'Abdeckung vorhanden, aber mit relevanten Blindspots oder nicht zonenkonsistent.',
    ],
    0: <String>[
      'Unzureichende Überwachungsabdeckung.',
    ],
  },
  'B-CTRL-08': <int, List<String>>{
    0: <String>[
      'Keine Regeln für Zugriff/Betrieb.',
    ],
    1: <String>[
      'Ad-hoc-Zugriffe, Rollen unklar.',
    ],
    2: <String>[
      'Wiederholbar geregelt, aber inkonsistent/ohne Überwachung.',
    ],
    3: <String>[
      'Definierte Rollen-/Zugriffssteuerung, Betriebsverfahren und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Berechtigungsreviews, Integritäts-/Manipulationsschutz geprüft).',
    ],
    5: <String>[
      'Optimiert (starke Governance, Automatisierung, kontinuierliche Verbesserung und Auditfähigkeit).',
    ],
  },
  'B-CTRL-09': <int, List<String>>{
    2: <String>[
      'Zweck, Aufbewahrung und Löschung sind geregelt und umgesetzt.',
    ],
    1: <String>[
      'Regeln existieren, aber unvollständig (z. B. keine klare Frist oder Ausnahmen ungesteuert).',
    ],
    0: <String>[
      'Keine regelkonforme Zweck-/Retention-/Löschregelung.',
    ],
  },
  'B-CTRL-10': <int, List<String>>{
    2: <String>[
      'Identifikation/Registrierung sowie zeitliche und räumliche Begrenzung sind umgesetzt.',
    ],
    1: <String>[
      'Prozess vorhanden, aber mit Lücken (z. B. keine Zonengrenze oder keine Befristung).',
    ],
    0: <String>[
      'Keine verlässliche Identifikation/Registrierung/Begrenzung.',
    ],
  },
  'B-CTRL-11': <int, List<String>>{
    2: <String>[
      'Sicherheitsregeln sind definiert und gelten verbindlich für Fremdfirmen.',
    ],
    1: <String>[
      'Regeln existieren, sind aber unvollständig oder nicht für alle Tätigkeiten/Teams verbindlich.',
    ],
    0: <String>[
      'Keine definierten Regeln.',
    ],
  },
  'B-CTRL-12': <int, List<String>>{
    0: <String>[
      'Keine Organisation/keine Kontrollen.',
    ],
    1: <String>[
      'Ad-hoc-Organisation, stark personenabhängig.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards/Übergabepunkte/klare Verantwortungen.',
    ],
    3: <String>[
      'Definierter Ablauf (Übergabepunkte, Wegeführung, Verantwortliche) und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (Abnahme/Übergabe, Kontrollen, Abweichungsmanagement).',
    ],
    5: <String>[
      'Optimiert (standardisierte Abläufe, kontinuierliche Verbesserung, geringe Vorfallquote).',
    ],
  },
  'B-CTRL-13': <int, List<String>>{
    2: <String>[
      'Physische Sicherung ist zonengerecht umgesetzt (Racks/Cages/Schutzbereiche).',
    ],
    1: <String>[
      'Sicherung vorhanden, aber inkonsistent oder mit Lücken in relevanten Bereichen.',
    ],
    0: <String>[
      'Keine zonengerechte physische Sicherung.',
    ],
  },
  'B-CTRL-14': <int, List<String>>{
    0: <String>[
      'Keine Verwaltung/kein Inventar.',
    ],
    1: <String>[
      'Ad-hoc-Ausgabe/Rücknahme, keine Nachvollziehbarkeit.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards (z. B. Verlustprozess/Inventur fehlt).',
    ],
    3: <String>[
      'Definierter Prozess (Ausgabe, Rückgabe, Verlust, Sperrung, Ersatz) und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Inventuren, Ausnahmen gesteuert, Review der Berechtigungen).',
    ],
    5: <String>[
      'Optimiert (Automatisierung/Integration, sehr hohe Nachvollziehbarkeit, geringe Verlustquote).',
    ],
  },
  'B-CTRL-15': <int, List<String>>{
    2: <String>[
      'Technische/organisatorische Maßnahmen verhindern oder detektieren Tailgating in Hochzonen.',
    ],
    1: <String>[
      'Maßnahmen existieren, aber nicht für alle Hochzonen oder mit relevanten Lücken.',
    ],
    0: <String>[
      'Keine wirksamen Maßnahmen gegen Tailgating.',
    ],
  },
  'C-CTRL-01': <int, List<String>>{
    0: <String>[
      'Kein zentrales Monitoring kritischer Parameter.',
    ],
    1: <String>[
      'Monitoring punktuell/ad-hoc, stark team- oder systemabhängig.',
    ],
    2: <String>[
      'Wiederholbar vorhanden, aber Abdeckung/Standardisierung lückenhaft.',
    ],
    3: <String>[
      'Monitoring-Modell definiert (Parameterumfang, Zuständigkeiten, Quellen) und durchgängig umgesetzt.',
    ],
    4: <String>[
      'Aktiv gemanagt (regelmäßige Abdeckungs-/Qualitätsreviews, definierte Pflegeprozesse).',
    ],
    5: <String>[
      'Optimiert (kontinuierliche Verbesserung, Automatisierung/Standardisierung, systematisches Coverage-Management).',
    ],
  },
  'C-CTRL-02': <int, List<String>>{
    0: <String>[
      'Keine definierten Alarmierungsregeln.',
    ],
    1: <String>[
      'Einzelne Regeln ad-hoc, hohe Noise-/Blindspot-Quote.',
    ],
    2: <String>[
      'Grundregeln vorhanden, Pflege/Abstimmung uneinheitlich.',
    ],
    3: <String>[
      'Regeln standardisiert (Schwellenwerte, Prioritäten, Abhängigkeiten) und konsistent umgesetzt.',
    ],
    4: <String>[
      'Alarmqualität gemanagt (Korrelation/Suppression, Wartungsmodi, regelmäßiges Tuning).',
    ],
    5: <String>[
      'Optimiert (kontinuierliche Reduktion von Noise, Automatisierung, systematische Wirksamkeitsmessung).',
    ],
  },
  'C-CTRL-03': <int, List<String>>{
    0: <String>[
      'Keine geregelte Alarm-/Eskalationskette.',
    ],
    1: <String>[
      'Eskalation personenabhängig, unklar/inkonsistent.',
    ],
    2: <String>[
      'Eskalationswege vorhanden, aber nicht zuverlässig angewendet.',
    ],
    3: <String>[
      'Rollenbasierte Kette definiert (On-Call, Eskalationsstufen, Verantwortlichkeiten) und gelebte Praxis.',
    ],
    4: <String>[
      'Gemanagt (Coverage/Erreichbarkeit überwacht, Zielzeiten definiert, regelmäßige Tests/Reviews).',
    ],
    5: <String>[
      'Optimiert (Übungen/Simulationen, kontinuierliche Verbesserungen, hohe Zuverlässigkeit).',
    ],
  },
  'C-CTRL-04': <int, List<String>>{
    0: <String>[
      'Kein Incident-Prozess.',
    ],
    1: <String>[
      'Ad-hoc-Bearbeitung ohne konsistente Klassifikation.',
    ],
    2: <String>[
      'Wiederholbar, aber Dokumentation/Standards lückenhaft.',
    ],
    3: <String>[
      'Definierter Incident-Prozess inkl. Kritikalität, Rollen und Abschlusskriterien.',
    ],
    4: <String>[
      'Gemanagt (Major-Incident-Handling, Review/Root-Cause bei relevanten Incidents, Steuerung über Kennzahlen).',
    ],
    5: <String>[
      'Optimiert (Lessons Learned systematisch, messbare Prozessverbesserung, hohe Wiederholbarkeit).',
    ],
  },
  'C-CTRL-05': <int, List<String>>{
    0: <String>[
      'Kein Change-Prozess.',
    ],
    1: <String>[
      'Ad-hoc-Changes, Freigaben uneinheitlich.',
    ],
    2: <String>[
      'Wiederholbar, aber Risiko-/Freigabelogik inkonsistent.',
    ],
    3: <String>[
      'Definierter Change-Prozess inkl. Risiko, Freigabe, Wartungsfenster und Emergency-Change-Regeln.',
    ],
    4: <String>[
      'Gemanagt (CAB/Reviews, Change-Qualitätssteuerung, Rollback-Standards).',
    ],
    5: <String>[
      'Optimiert (Standardisierung/Automatisierung, kontinuierliche Verbesserung, sehr geringe Change-Failure-Rate).',
    ],
  },
  'C-CTRL-06': <int, List<String>>{
    0: <String>[
      'Wartung rein reaktiv.',
    ],
    1: <String>[
      'Einzelwartungen ad-hoc, ohne Koordination.',
    ],
    2: <String>[
      'Wiederholbar geplant, aber Abhängigkeiten/Kommunikation lückenhaft.',
    ],
    3: <String>[
      'Definierte Wartungsplanung inkl. Koordination, Abhängigkeiten, Freigaben.',
    ],
    4: <String>[
      'Gemanagt (Wartungsfenster, Risiko-/Impact-Bewertung, Qualitätskontrollen, Störungsminimierung).',
    ],
    5: <String>[
      'Optimiert (präventive/predictive Steuerung, kontinuierliche Verbesserung, hohe Stabilität).',
    ],
  },
  'C-CTRL-07': <int, List<String>>{
    0: <String>[
      'Keine definierte Kapazitätssicht.',
    ],
    1: <String>[
      'Ad-hoc-Betrachtung bei Engpässen.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne konsistente Methodik/Abdeckung.',
    ],
    3: <String>[
      'Definierter Kapazitätsprozess mit regelmäßigen Reviews (Power/Cooling/Space).',
    ],
    4: <String>[
      'Gemanagt (Trend, Forecast-Basis, Verantwortlichkeiten, Steuerungsmaßnahmen).',
    ],
    5: <String>[
      'Optimiert (frühe Engpassprävention, automatisierte Auswertungen, kontinuierliche Verbesserung).',
    ],
  },
  'C-CTRL-08': <int, List<String>>{
    2: <String>[
      'Grenzen und Reserven sind vollständig festgelegt und gelten für alle relevanten Kapazitätsdimensionen.',
    ],
    1: <String>[
      'Grenzen/Reserven sind nur für Teilbereiche definiert oder nicht konsistent (z. B. nur Power, nicht Cooling/Space).',
    ],
    0: <String>[
      'Keine definierten Grenzen/Reserven.',
    ],
  },
  'C-CTRL-09': <int, List<String>>{
    0: <String>[
      'Keine vorausschauende Planung.',
    ],
    1: <String>[
      'Planung reaktiv, kurzfristig.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne konsistente Abstimmung/Methodik.',
    ],
    3: <String>[
      'Definierter Planungsprozess, der Wachstum/Projekte systematisch einbezieht.',
    ],
    4: <String>[
      'Gemanagt (Forecasting, Projekt-/Change-Abstimmung, Maßnahmen-Tracking).',
    ],
    5: <String>[
      'Optimiert (Szenarioplanung, hohe Prognosequalität, geringe Engpassrisiken).',
    ],
  },
  'C-CTRL-10': <int, List<String>>{
    0: <String>[
      'Wesentliche Dokumentation fehlt.',
    ],
    1: <String>[
      'Fragmentiert/veraltet, keine klare Zuständigkeit.',
    ],
    2: <String>[
      'Wiederholbar genutzt, Pflege/Versionierung uneinheitlich.',
    ],
    3: <String>[
      'Definiert (Dokumentenarten, Verantwortliche, Versionierung, Zugriff) und umgesetzt.',
    ],
    4: <String>[
      'Gemanagt (Review-Zyklen, Qualitätsstandards, Aktualitätssteuerung).',
    ],
    5: <String>[
      'Optimiert (hohe Nutzbarkeit, kontinuierliche Verbesserung, Standardisierung).',
    ],
  },
  'C-CTRL-11': <int, List<String>>{
    0: <String>[
      'Keine konsistente Bestands-/Konfigurationssicht.',
    ],
    1: <String>[
      'Ad-hoc-Listen, stark veraltet/inkonsistent.',
    ],
    2: <String>[
      'Wiederholbar gepflegt, aber ohne Standards/Vollständigkeit.',
    ],
    3: <String>[
      'Definierte Pflege (Objekte/Attribute/Verantwortliche) und konsistente Umsetzung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Abgleiche, Qualitätskontrollen, Change-Integration).',
    ],
    5: <String>[
      'Optimiert (automatisierte Abgleiche, sehr hohe Datenqualität).',
    ],
  },
  'C-CTRL-12': <int, List<String>>{
    2: <String>[
      'KPI-Set ist definiert und deckt Stabilität, Reaktionsfähigkeit und Prozessqualität ab.',
    ],
    1: <String>[
      'KPIs sind definiert, aber Abdeckung ist unvollständig (z. B. nur Verfügbarkeit, keine Prozessqualität).',
    ],
    0: <String>[
      'Keine definierten Betriebskennzahlen.',
    ],
  },
  'C-CTRL-13': <int, List<String>>{
    0: <String>[
      'Keine Auswertung/keine Maßnahmen.',
    ],
    1: <String>[
      'Unregelmäßig, ohne systematische Nachverfolgung.',
    ],
    2: <String>[
      'Wiederholbar, Nachverfolgung aber uneinheitlich.',
    ],
    3: <String>[
      'Regelmäßige Reviews, Maßnahmen mit Owner/Termin, Tracking vorhanden.',
    ],
    4: <String>[
      'Gemanagt (Wirksamkeitsprüfung, Trendsteuerung, Management-Review).',
    ],
    5: <String>[
      'Optimiert (kontinuierlicher Verbesserungsprozess, messbarer Effekt, Anpassung des KPI-Sets).',
    ],
  },
  'C-CTRL-14': <int, List<String>>{
    2: <String>[
      'Leistungs- und Reaktionsanforderungen sind klar festgelegt und gelten für alle relevanten kritischen Lieferantenleistungen.',
    ],
    1: <String>[
      'Anforderungen existieren nur für Teilbereiche oder sind nicht eindeutig (z. B. unklare Reaktionszeiten).',
    ],
    0: <String>[
      'Keine klaren Anforderungen/keine Steuerungsbasis.',
    ],
  },
  'C-CTRL-15': <int, List<String>>{
    0: <String>[
      'Einsätze unkoordiniert.',
    ],
    1: <String>[
      'Ad-hoc-Absprachen, keine Standards.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne durchgängige Prozessintegration.',
    ],
    3: <String>[
      'Definiert (Work-Order/Ticket, Terminierung, Abstimmung mit Change/Maintenance, Abnahme).',
    ],
    4: <String>[
      'Gemanagt (Qualitätskontrolle, Übergabe/Abnahme standardisiert, Minimierung von Beeinträchtigungen).',
    ],
    5: <String>[
      'Optimiert (hohe Planbarkeit, standardisierte Abläufe, kontinuierliche Verbesserung).',
    ],
  },
  'C-CTRL-16': <int, List<String>>{
    0: <String>[
      'Keine Reviews/kein Abweichungsmanagement.',
    ],
    1: <String>[
      'Reaktiv bei Problemen.',
    ],
    2: <String>[
      'Wiederholbar, Maßnahmen aber inkonsistent nachverfolgt.',
    ],
    3: <String>[
      'Regelmäßige Reviews, Abweichungen werden dokumentiert und adressiert.',
    ],
    4: <String>[
      'Gemanagt (KPI/SLA-basierte Steuerung, Eskalationen, Maßnahmen-Tracking).',
    ],
    5: <String>[
      'Optimiert (kontinuierliche Leistungsverbesserung, strategische Partnersteuerung).',
    ],
  },
  'C-CTRL-17': <int, List<String>>{
    0: <String>[
      'Kein geregelter Update-Prozess.',
    ],
    1: <String>[
      'Updates ad-hoc/situativ.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne klare Standards/Planung/Transparenz.',
    ],
    3: <String>[
      'Definierter Prozess inkl. Priorisierung, Planung, Freigabe und Wartungsfenstern.',
    ],
    4: <String>[
      'Gemanagt (Risiko-/Vulnerability-Input, Reporting, Qualitätskontrolle nach Updates).',
    ],
    5: <String>[
      'Optimiert (Automatisierung, kontinuierliche Verbesserung, minimierte Betriebsrisiken).',
    ],
  },
  'D-CTRL-01': <int, List<String>>{
    2: <String>[
      'Mindestens zwei unabhängige Anbindungen/Provider sind vorhanden und so gestaltet, dass ein Single-Provider-/Single-Link-Ausfall abgefangen wird.',
    ],
    1: <String>[
      'Redundanz vorhanden, aber mit relevanten gemeinsamen Abhängigkeiten oder nur für Teilservices.',
    ],
    0: <String>[
      'Keine wirksame Redundanz der externen Anbindung.',
    ],
  },
  'D-CTRL-02': <int, List<String>>{
    2: <String>[
      'Failover-Mechanismen sind implementiert und erfüllen die definierten Zielwerte (z. B. Konvergenz/Failover-Verhalten).',
    ],
    1: <String>[
      'Failover vorhanden, aber Zielwerte werden nicht durchgängig erreicht oder gelten nur für Teilpfade.',
    ],
    0: <String>[
      'Kein wirksamer Failover oder keine Zielwerte/Umsetzung.',
    ],
  },
  'D-CTRL-03': <int, List<String>>{
    2: <String>[
      'Physische Wegediversität/Trassen- und Übergabepunktdiversität ist umgesetzt; gemeinsame Ausfallursachen sind minimiert.',
    ],
    1: <String>[
      'Diversität vorhanden, aber einzelne gemeinsame Abhängigkeiten bestehen.',
    ],
    0: <String>[
      'Hohe gemeinsame Abhängigkeiten (z. B. gleiche Trasse/POP) ohne Kompensation.',
    ],
  },
  'D-CTRL-04': <int, List<String>>{
    2: <String>[
      'Redundanzdesign ist umgesetzt; kritische Komponenten/Pfade haben keine Single Points of Failure.',
    ],
    1: <String>[
      'Redundanz nur in Teilbereichen oder mit verbleibenden Single Points of Failure.',
    ],
    0: <String>[
      'Keine wirksame Redundanz kritischer Komponenten/Pfade.',
    ],
  },
  'D-CTRL-05': <int, List<String>>{
    2: <String>[
      'Mechanismen sind so konfiguriert, dass definierte Szenarien (Gerät/Link) ohne ungeplanten Serviceabbruch beherrscht werden.',
    ],
    1: <String>[
      'Mechanismen vorhanden, aber nicht für alle definierten Szenarien oder mit relevanten Einschränkungen.',
    ],
    0: <String>[
      'Failover nicht wirksam oder führt zu ungeplanten Abbrüchen.',
    ],
  },
  'D-CTRL-06': <int, List<String>>{
    0: <String>[
      'Keine aktuelle Dokumentation.',
    ],
    1: <String>[
      'Ad-hoc-Dokumente, stark veraltet.',
    ],
    2: <String>[
      'Wiederholbar gepflegt, aber ohne Standards/Triggers.',
    ],
    3: <String>[
      'Dokumentationsstandard und Update-Trigger definiert und konsistent angewendet.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Reviews, Qualitätskontrollen, Freigaben).',
    ],
    5: <String>[
      'Optimiert (automatisierte Aktualisierung/Abgleich, sehr hohe Aktualität).',
    ],
  },
  'D-CTRL-07': <int, List<String>>{
    2: <String>[
      'Zonen/Segmente sind definiert und umgesetzt; Zuordnung folgt Schutzbedarf und Zweck.',
    ],
    1: <String>[
      'Segmentierung vorhanden, aber unvollständig oder inkonsistent (z. B. Schattennetze).',
    ],
    0: <String>[
      'Keine wirksame Segmentierung/Zonierung.',
    ],
  },
  'D-CTRL-08': <int, List<String>>{
    2: <String>[
      'Inter-Zone-Kommunikation ist restriktiv, explizit freigegeben und technisch erzwungen.',
    ],
    1: <String>[
      'Absicherung vorhanden, aber mit zu breiten Regeln/unklaren Ausnahmen.',
    ],
    0: <String>[
      'Übergänge unkontrolliert oder weitgehend offen.',
    ],
  },
  'D-CTRL-09': <int, List<String>>{
    2: <String>[
      'Separates Management-Konzept ist umgesetzt; Adminzugriffe sind abgesichert und getrennt.',
    ],
    1: <String>[
      'Trennung oder Absicherung ist nur teilweise umgesetzt.',
    ],
    0: <String>[
      'Adminzugriffe laufen ungeschützt oder im Produktionsnetz ohne Trennung.',
    ],
  },
  'D-CTRL-10': <int, List<String>>{
    0: <String>[
      'Keine eindeutige Kennzeichnung/keine Verwaltung.',
    ],
    1: <String>[
      'Ad-hoc-Kennzeichnung, inkonsistente Benennung.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards/Qualitätssicherung.',
    ],
    3: <String>[
      'Standard definiert (Labeling, Port-/Patchfeldreferenzen) und konsistent umgesetzt.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Abgleiche, Qualitätskontrollen, Change-Integration).',
    ],
    5: <String>[
      'Optimiert (automatisierte Inventur/Abgleich, sehr hohe Datenqualität).',
    ],
  },
  'D-CTRL-11': <int, List<String>>{
    0: <String>[
      'Änderungen unkontrolliert.',
    ],
    1: <String>[
      'Ad-hoc-Änderungen ohne Standards.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne konsequentes Vier-Augen-/Wartungsfensterprinzip.',
    ],
    3: <String>[
      'Definierter Change-Ablauf inkl. Planung, Wartungsfenster und Verifikation.',
    ],
    4: <String>[
      'Gemanagt (Qualitätskontrollen, Fehlpatching-Prevention, Maßnahmen bei Abweichungen).',
    ],
    5: <String>[
      'Optimiert (Standardisierung, sehr geringe Fehlpatching-Rate, kontinuierliche Verbesserung).',
    ],
  },
  'D-CTRL-12': <int, List<String>>{
    2: <String>[
      'Diversitätsanforderungen sind bei relevanten Änderungen geprüft und eingehalten.',
    ],
    1: <String>[
      'Prüfung erfolgt, aber nicht durchgängig oder ohne klare Kriterien.',
    ],
    0: <String>[
      'Diversität/Abhängigkeiten werden nicht berücksichtigt.',
    ],
  },
  'D-CTRL-13': <int, List<String>>{
    2: <String>[
      'OOB-Pfad ist unabhängig und ermöglicht Adminzugriff bei Produktionsnetzstörung.',
    ],
    1: <String>[
      'OOB existiert, ist aber nicht ausreichend unabhängig oder deckt nicht alle kritischen Komponenten ab.',
    ],
    0: <String>[
      'Kein wirksamer OOB-Zugriff.',
    ],
  },
  'D-CTRL-14': <int, List<String>>{
    2: <String>[
      'Starke Authentisierung/Autorisierung ist umgesetzt; Zugriff ist restriktiv und zweckgebunden.',
    ],
    1: <String>[
      'Absicherung vorhanden, aber mit Lücken (z. B. zu breite Gruppen, fehlende MFA).',
    ],
    0: <String>[
      'OOB-Zugriff unzureichend abgesichert.',
    ],
  },
  'D-CTRL-15': <int, List<String>>{
    0: <String>[
      'Kein Break-Glass-Konzept.',
    ],
    1: <String>[
      'Ad-hoc-Notfallzugriffe ohne Regelung.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne klare Freigaben/Nachbearbeitung.',
    ],
    3: <String>[
      'Definierter Prozess (Aktivierung, Freigabe, zeitliche Begrenzung, Review) und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Tests/Übungen, Nachkontrollen, Ausnahme-Tracking).',
    ],
    5: <String>[
      'Optimiert (hohe Sicherheit und Handlungsfähigkeit, kontinuierliche Verbesserung, sehr gute Auditfähigkeit).',
    ],
  },
  'D-CTRL-16': <int, List<String>>{
    0: <String>[
      'Keine Konfigurationssicherung.',
    ],
    1: <String>[
      'Ad-hoc-Backups, personenabhängig.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards/Schutz/Restore-Prozess.',
    ],
    3: <String>[
      'Definierter Backup- und Restore-Prozess (Frequenz, Scope, Rollen) und konsistente Durchführung.',
    ],
    4: <String>[
      'Gemanagt (Restore-Tests, Integritäts-/Vollständigkeitschecks, Abweichungsmanagement).',
    ],
    5: <String>[
      'Optimiert (Automatisierung, sehr hohe Zuverlässigkeit, geringe Recovery-Zeit).',
    ],
  },
  'E-CTRL-01': <int, List<String>>{
    2: <String>[
      'Governance ist formal festgelegt, gilt für den RZ-Scope und ist organisatorisch verankert.',
    ],
    1: <String>[
      'Governance existiert, ist aber unvollständig (z. B. Scope unklar, fehlende Entscheidungsbefugnisse).',
    ],
    0: <String>[
      'Keine verbindliche BCM-Governance.',
    ],
  },
  'E-CTRL-02': <int, List<String>>{
    0: <String>[
      'Keine Notfallorganisation.',
    ],
    1: <String>[
      'Informell/Ad-hoc, abhängig von Einzelpersonen.',
    ],
    2: <String>[
      'Rollen vorhanden, aber Vertretungen/Erreichbarkeit uneinheitlich.',
    ],
    3: <String>[
      'Rollen, Vertretungen und Erreichbarkeit definiert und konsistent umgesetzt.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Übungen/Verifikationen, Aktualitätsreviews der Kontaktwege).',
    ],
    5: <String>[
      'Optimiert (hohe Robustheit, Simulationen, kontinuierliche Verbesserung).',
    ],
  },
  'E-CTRL-03': <int, List<String>>{
    0: <String>[
      'Keine definierten BCM-Prozesse.',
    ],
    1: <String>[
      'Ad-hoc-Aktivierung, keine klare Lagebewertung.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards/Abstimmung.',
    ],
    3: <String>[
      'Definierte Prozesse inkl. Trigger, Rollen, Schnittstellen und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Reviews/Übungen, Lessons Learned fließen ein).',
    ],
    5: <String>[
      'Optimiert (hohe Wirksamkeit, kontinuierliche Verbesserung, sehr gute Verzahnung).',
    ],
  },
  'E-CTRL-04': <int, List<String>>{
    2: <String>[
      'DR-Strategie ist definiert und deckt kritische Services/Servicegruppen ab.',
    ],
    1: <String>[
      'Strategie existiert, aber Scope/Serviceabdeckung oder Zielbild ist unvollständig.',
    ],
    0: <String>[
      'Keine definierte DR-Strategie.',
    ],
  },
  'E-CTRL-05': <int, List<String>>{
    2: <String>[
      'DR-Fähigkeiten (Umgebung, Abhängigkeiten) decken kritische Services gemäß Zielbild ab.',
    ],
    1: <String>[
      'DR-Fähigkeiten vorhanden, aber nicht für alle kritischen Services oder mit relevanten Lücken.',
    ],
    0: <String>[
      'DR-Fähigkeiten unzureichend.',
    ],
  },
  'E-CTRL-06': <int, List<String>>{
    0: <String>[
      'Keine DR-Tests.',
    ],
    1: <String>[
      'Ad-hoc-Tests ohne Planung.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards/Auswertung.',
    ],
    3: <String>[
      'Testplan (Zyklus, Szenarien, Rollen) definiert und konsistent umgesetzt.',
    ],
    4: <String>[
      'Gemanagt (Lessons Learned, Maßnahmen-Tracking, Re-Test nach Änderungen).',
    ],
    5: <String>[
      'Optimiert (vielfältige Testarten, hohe Realitätsnähe, kontinuierliche Verbesserung).',
    ],
  },
  'E-CTRL-07': <int, List<String>>{
    2: <String>[
      'RTO/RPO sind für kritische Services/Servicegruppen definiert und priorisiert.',
    ],
    1: <String>[
      'Zielwerte existieren, aber nicht für alle kritischen Services oder ohne klare Priorisierung.',
    ],
    0: <String>[
      'Keine definierten RTO/RPO.',
    ],
  },
  'E-CTRL-08': <int, List<String>>{
    0: <String>[
      'Keine Abstimmung mit Abhängigkeiten.',
    ],
    1: <String>[
      'Ad-hoc-Abstimmungen, nicht dokumentiert.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne konsistente Methodik.',
    ],
    3: <String>[
      'Definierter Abstimmprozess (Abhängigkeiten, Reviews, Freigaben) und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (regelmäßige Revalidierung, Change-Trigger, Maßnahmenableitung bei Lücken).',
    ],
    5: <String>[
      'Optimiert (Szenario-Planung, hohe Umsetzbarkeit, kontinuierliche Verbesserung).',
    ],
  },
  'E-CTRL-09': <int, List<String>>{
    2: <String>[
      'Pläne decken relevante Szenarien ab und adressieren kritische Betriebsfunktionen.',
    ],
    1: <String>[
      'Pläne existieren, aber Szenario- oder Funktionsabdeckung ist unvollständig.',
    ],
    0: <String>[
      'Keine ausreichenden Pläne.',
    ],
  },
  'E-CTRL-10': <int, List<String>>{
    2: <String>[
      'Pläne enthalten klare Rollen, Reihenfolgen, Abhängigkeiten und Entscheidungspunkte.',
    ],
    1: <String>[
      'Pläne enthalten Teile davon, aber es fehlen relevante Elemente (z. B. Abhängigkeiten/Go-No-Go).',
    ],
    0: <String>[
      'Pläne sind nicht ausführbar/zu unklar.',
    ],
  },
  'E-CTRL-11': <int, List<String>>{
    0: <String>[
      'Keine Versionierung/keine Pflege.',
    ],
    1: <String>[
      'Ad-hoc-Updates, stark personenabhängig.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne klare Trigger/Reviews.',
    ],
    3: <String>[
      'Definierter Pflegeprozess (Versionierung, Owner, Trigger, Reviewzyklus) und konsistente Anwendung.',
    ],
    4: <String>[
      'Gemanagt (Qualitätsreviews, Change-Integration, Freigaben).',
    ],
    5: <String>[
      'Optimiert (hohe Aktualität, automatisierte Trigger/Checks, kontinuierliche Verbesserung).',
    ],
  },
  'E-CTRL-12': <int, List<String>>{
    2: <String>[
      'Kriterien/Wege sind definiert und beziehen sich auf den Krisenmodus/Notbetrieb.',
    ],
    1: <String>[
      'Eskalation ist geregelt, aber Kriterien/Entscheidungsebenen unklar.',
    ],
    0: <String>[
      'Keine klare Eskalation für Krisenmodus.',
    ],
  },
  'E-CTRL-13': <int, List<String>>{
    0: <String>[
      'Keine Krisenkommunikationsprozesse.',
    ],
    1: <String>[
      'Ad-hoc-Kommunikation.',
    ],
    2: <String>[
      'Wiederholbar, aber ohne Standards/Freigaben.',
    ],
    3: <String>[
      'Definierter Prozess (Rollen, Zielgruppen, Kanäle, Mindestinhalte, Freigaben) und Anwendung.',
    ],
    4: <String>[
      'Gemanagt (Templates, regelmäßige Übungen, Review der Wirksamkeit).',
    ],
    5: <String>[
      'Optimiert (sehr hohe Klarheit, kontinuierliche Verbesserung, starke Stakeholder-Steuerung).',
    ],
  },
  'E-CTRL-14': <int, List<String>>{
    2: <String>[
      'Backup- und Restore-Fähigkeit unterstützt die definierten RPO-Ziele für kritische Services.',
    ],
    1: <String>[
      'Backups existieren, aber RPO-Unterstützung oder Restore-Fähigkeit ist nicht durchgängig.',
    ],
    0: <String>[
      'Backup/Restore unterstützt RPO-Ziele nicht.',
    ],
  },
};

const List<ChecklistCriterion> criteria = <ChecklistCriterion>[
  ChecklistCriterion(
    criteriaId: 'A-CTRL-01-CRIT-01',
    controlId: 'A-CTRL-01',
    text:
        'Es existiert eine klare Segmentierung zwischen internen Netzen, Managementnetzen und extern zugänglichen Systemen.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-01-CRIT-02',
    controlId: 'A-CTRL-01',
    text:
        'Firewalls kontrollieren den Datenverkehr zwischen den Netzwerksegmenten.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-01-CRIT-03',
    controlId: 'A-CTRL-01',
    text: 'Firewall-Regeln sind dokumentiert und regelmäßig überprüft.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-01-CRIT-04',
    controlId: 'A-CTRL-01',
    text: 'Administrative Zugriffe erfolgen über gesicherte Managementnetze.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-01-CRIT-05',
    controlId: 'A-CTRL-01',
    text: 'Unnötige offene Ports und Dienste wurden deaktiviert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-02-CRIT-01',
    controlId: 'A-CTRL-02',
    text:
        'Nicht benötigte Dienste und Softwarekomponenten wurden entfernt oder deaktiviert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-02-CRIT-02',
    controlId: 'A-CTRL-02',
    text:
        'Sicherheitsrichtlinien für Serverkonfigurationen sind definiert und umgesetzt.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-02-CRIT-03',
    controlId: 'A-CTRL-02',
    text: 'Standardpasswörter wurden geändert oder deaktiviert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-02-CRIT-04',
    controlId: 'A-CTRL-02',
    text: 'Administrationszugänge sind eingeschränkt und protokolliert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-02-CRIT-05',
    controlId: 'A-CTRL-02',
    text: 'Serverkonfigurationen folgen definierten Sicherheitsstandards.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-03-CRIT-01',
    controlId: 'A-CTRL-03',
    text: 'Es existiert ein dokumentierter Prozess für das Patch-Management.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-03-CRIT-02',
    controlId: 'A-CTRL-03',
    text: 'Sicherheitsupdates werden regelmäßig installiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-03-CRIT-03',
    controlId: 'A-CTRL-03',
    text: 'Kritische Sicherheitsupdates werden zeitnah umgesetzt.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-03-CRIT-04',
    controlId: 'A-CTRL-03',
    text: 'Patchstände werden zentral überwacht.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-03-CRIT-05',
    controlId: 'A-CTRL-03',
    text:
        'Systeme ohne aktuellen Patchstand werden identifiziert und behandelt.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-04-CRIT-01',
    controlId: 'A-CTRL-04',
    text: 'Kritische Systeme sind redundant ausgelegt.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-04-CRIT-02',
    controlId: 'A-CTRL-04',
    text:
        'Ausfall einzelner Komponenten führt nicht zum vollständigen Systemstillstand.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-04-CRIT-03',
    controlId: 'A-CTRL-04',
    text:
        'Hochverfügbarkeitsmechanismen sind implementiert, sofern erforderlich.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-04-CRIT-04',
    controlId: 'A-CTRL-04',
    text:
        'Infrastrukturkomponenten sind gegen Single Points of Failure abgesichert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-04-CRIT-05',
    controlId: 'A-CTRL-04',
    text: 'Wiederanlaufverfahren bei Systemausfällen sind dokumentiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-05-CRIT-01',
    controlId: 'A-CTRL-05',
    text: 'Infrastrukturkomponenten werden zentral überwacht.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-05-CRIT-02',
    controlId: 'A-CTRL-05',
    text: 'Kritische Systemereignisse werden automatisch erkannt.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-05-CRIT-03',
    controlId: 'A-CTRL-05',
    text:
        'Alarme werden bei Systemausfällen oder ungewöhnlichen Aktivitäten ausgelöst.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-05-CRIT-04',
    controlId: 'A-CTRL-05',
    text: 'Monitoring-Daten werden protokolliert und ausgewertet.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-05-CRIT-05',
    controlId: 'A-CTRL-05',
    text:
        'Verantwortliche Personen werden im Störungsfall automatisch informiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-01-CRIT-01',
    controlId: 'B-CTRL-01',
    text: 'Zutritt erfolgt ausschließlich über autorisierte Berechtigungen.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-01-CRIT-02',
    controlId: 'B-CTRL-01',
    text: 'Zutrittsrechte sind rollenbasiert vergeben.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-01-CRIT-03',
    controlId: 'B-CTRL-01',
    text: 'Zugangssysteme protokollieren Zutritte.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-01-CRIT-04',
    controlId: 'B-CTRL-01',
    text: 'Berechtigungen werden regelmäßig überprüft.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-02-CRIT-01',
    controlId: 'B-CTRL-02',
    text: 'Zwei-Faktor-Authentisierung in kritischen Bereichen vorhanden.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-02-CRIT-02',
    controlId: 'B-CTRL-02',
    text: 'Authentisierung entspricht dem Schutzbedarf der Zone.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-02-CRIT-03',
    controlId: 'B-CTRL-02',
    text: 'Zugangssysteme sind gegen Missbrauch geschützt.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-03-CRIT-01',
    controlId: 'B-CTRL-03',
    text: 'Joiner-Mover-Leaver Prozesse existieren.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-03-CRIT-02',
    controlId: 'B-CTRL-03',
    text: 'Berechtigungen werden regelmäßig überprüft.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-03-CRIT-03',
    controlId: 'B-CTRL-03',
    text:
        'Entzug von Zutrittsrechten erfolgt zeitnah bei Rollenwechsel oder Austritt.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-07-CRIT-01',
    controlId: 'B-CTRL-07',
    text: 'Kritische Bereiche werden videoüberwacht.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-07-CRIT-02',
    controlId: 'B-CTRL-07',
    text: 'Aufzeichnungen werden gespeichert.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-07-CRIT-03',
    controlId: 'B-CTRL-07',
    text: 'Zugriff auf Videoaufzeichnungen ist geregelt.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-10-CRIT-01',
    controlId: 'B-CTRL-10',
    text: 'Besucher werden registriert.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-10-CRIT-02',
    controlId: 'B-CTRL-10',
    text: 'Besucher erhalten zeitlich begrenzte Zutrittsrechte.',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-10-CRIT-03',
    controlId: 'B-CTRL-10',
    text: 'Begleitpflicht in sensiblen Bereichen wird umgesetzt.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-01-CRIT-01',
    controlId: 'C-CTRL-01',
    text: 'Energieversorgung wird überwacht.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-01-CRIT-02',
    controlId: 'C-CTRL-01',
    text: 'Kühlungsinfrastruktur wird überwacht.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-01-CRIT-03',
    controlId: 'C-CTRL-01',
    text: 'Infrastrukturzustände werden zentral erfasst.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-02-CRIT-01',
    controlId: 'C-CTRL-02',
    text: 'Schwellwerte für Alarme sind definiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-02-CRIT-02',
    controlId: 'C-CTRL-02',
    text: 'Prioritäten für Ereignisse sind festgelegt.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-02-CRIT-03',
    controlId: 'C-CTRL-02',
    text: 'Eskalationsregeln sind dokumentiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-04-CRIT-01',
    controlId: 'C-CTRL-04',
    text: 'Incidentprozess ist definiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-04-CRIT-02',
    controlId: 'C-CTRL-04',
    text: 'Incidents werden nach Kritikalität klassifiziert.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-04-CRIT-03',
    controlId: 'C-CTRL-04',
    text: 'Nachbearbeitung und Lessons Learned erfolgen.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-05-CRIT-01',
    controlId: 'C-CTRL-05',
    text: 'Changes werden dokumentiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-05-CRIT-02',
    controlId: 'C-CTRL-05',
    text: 'Freigabeprozesse existieren.',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-05-CRIT-03',
    controlId: 'C-CTRL-05',
    text: 'Notfalländerungen sind geregelt.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-01-CRIT-01',
    controlId: 'D-CTRL-01',
    text: 'Mindestens zwei unabhängige Provider vorhanden.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-01-CRIT-02',
    controlId: 'D-CTRL-01',
    text: 'Providerübergaben sind physisch getrennt.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-01-CRIT-03',
    controlId: 'D-CTRL-01',
    text:
        'Ausfall einer Verbindung führt nicht zum Verlust der externen Konnektivität.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-04-CRIT-01',
    controlId: 'D-CTRL-04',
    text: 'Redundante Core-Komponenten vorhanden.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-04-CRIT-02',
    controlId: 'D-CTRL-04',
    text: 'Netzwerkpfade sind redundant ausgelegt.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-04-CRIT-03',
    controlId: 'D-CTRL-04',
    text: 'Single Points of Failure wurden minimiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-07-CRIT-01',
    controlId: 'D-CTRL-07',
    text: 'Sicherheitszonen sind definiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-07-CRIT-02',
    controlId: 'D-CTRL-07',
    text: 'Firewall oder ACL Regeln kontrollieren den Datenverkehr.',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-07-CRIT-03',
    controlId: 'D-CTRL-07',
    text: 'Unnötige Kommunikation zwischen Zonen ist blockiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-01-CRIT-01',
    controlId: 'E-CTRL-01',
    text: 'Verantwortlichkeiten im BCM sind definiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-01-CRIT-02',
    controlId: 'E-CTRL-01',
    text: 'BCM-Geltungsbereich ist dokumentiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-01-CRIT-03',
    controlId: 'E-CTRL-01',
    text: 'Schnittstellen zu anderen Bereichen sind festgelegt.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-04-CRIT-01',
    controlId: 'E-CTRL-04',
    text: 'DR-Strategie ist dokumentiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-04-CRIT-02',
    controlId: 'E-CTRL-04',
    text: 'Wiederanlaufverfahren sind definiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-04-CRIT-03',
    controlId: 'E-CTRL-04',
    text: 'Priorisierung kritischer Services existiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-06-CRIT-01',
    controlId: 'E-CTRL-06',
    text: 'DR-Tests werden regelmäßig durchgeführt.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-06-CRIT-02',
    controlId: 'E-CTRL-06',
    text: 'Ergebnisse der Tests werden dokumentiert.',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-06-CRIT-03',
    controlId: 'E-CTRL-06',
    text: 'Lessons Learned werden umgesetzt.',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-14-CRIT-01',
    controlId: 'A-CTRL-14',
    text: 'Verantwortlichkeiten sind festgelegt',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-14-CRIT-02',
    controlId: 'A-CTRL-14',
    text: 'Qualifikationsanforderungen sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-14-CRIT-03',
    controlId: 'A-CTRL-14',
    text: 'Rollen passen zur Kritikalität der Anlagen',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-15-CRIT-01',
    controlId: 'A-CTRL-15',
    text: 'Prüfintervalle sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-15-CRIT-02',
    controlId: 'A-CTRL-15',
    text: 'Wartungen werden fristgerecht durchgeführt',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-15-CRIT-03',
    controlId: 'A-CTRL-15',
    text: 'Nachweise zu Prüfungen sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-16-CRIT-01',
    controlId: 'A-CTRL-16',
    text: 'Sicherheitsverfahren ist verbindlich definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-16-CRIT-02',
    controlId: 'A-CTRL-16',
    text: 'Lockout/Tagout-Prinzip wird angewendet',
  ),
  ChecklistCriterion(
    criteriaId: 'A-CTRL-16-CRIT-03',
    controlId: 'A-CTRL-16',
    text: 'Sicherheitsmaßnahmen sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-04-CRIT-01',
    controlId: 'B-CTRL-04',
    text: 'Außenperimeter ist definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-04-CRIT-02',
    controlId: 'B-CTRL-04',
    text: 'Sicherheitszonen sind abgestuft umgesetzt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-04-CRIT-03',
    controlId: 'B-CTRL-04',
    text: 'Zutritt erfolgt schrittweise kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-05-CRIT-01',
    controlId: 'B-CTRL-05',
    text: 'Türen sind manipulationsgeschützt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-05-CRIT-02',
    controlId: 'B-CTRL-05',
    text: 'Notausgänge sind gesichert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-05-CRIT-03',
    controlId: 'B-CTRL-05',
    text: 'Eindringen über Nebenzugänge ist erschwert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-06-CRIT-01',
    controlId: 'B-CTRL-06',
    text: 'Lieferzonen sind abgesichert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-06-CRIT-02',
    controlId: 'B-CTRL-06',
    text: 'Nebenzugänge sind kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-06-CRIT-03',
    controlId: 'B-CTRL-06',
    text: 'Übergabezonen sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-08-CRIT-01',
    controlId: 'B-CTRL-08',
    text: 'Zugriffe sind rollenbasiert geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-08-CRIT-02',
    controlId: 'B-CTRL-08',
    text: 'Manipulation ist erschwert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-08-CRIT-03',
    controlId: 'B-CTRL-08',
    text: 'Löschung ist kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-09-CRIT-01',
    controlId: 'B-CTRL-09',
    text: 'Aufbewahrungsfristen sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-09-CRIT-02',
    controlId: 'B-CTRL-09',
    text: 'Zweck der Speicherung ist dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-09-CRIT-03',
    controlId: 'B-CTRL-09',
    text: 'Löschprozesse sind geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-11-CRIT-01',
    controlId: 'B-CTRL-11',
    text: 'Sicherheitsregeln sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-11-CRIT-02',
    controlId: 'B-CTRL-11',
    text: 'Begleitpflicht ist geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-11-CRIT-03',
    controlId: 'B-CTRL-11',
    text: 'Arbeitsbereiche sind begrenzt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-12-CRIT-01',
    controlId: 'B-CTRL-12',
    text: 'Übergaben sind kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-12-CRIT-02',
    controlId: 'B-CTRL-12',
    text: 'Transportwege sind gesichert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-12-CRIT-03',
    controlId: 'B-CTRL-12',
    text: 'Unbeaufsichtigte Tätigkeiten werden verhindert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-13-CRIT-01',
    controlId: 'B-CTRL-13',
    text: 'Rack-Locks sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-13-CRIT-02',
    controlId: 'B-CTRL-13',
    text: 'Cages sind gesichert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-13-CRIT-03',
    controlId: 'B-CTRL-13',
    text: 'Hochschutzbereiche sind zusätzlich abgesichert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-14-CRIT-01',
    controlId: 'B-CTRL-14',
    text: 'Ausgabe und Rückgabe sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-14-CRIT-02',
    controlId: 'B-CTRL-14',
    text: 'Verlustprozesse sind geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-14-CRIT-03',
    controlId: 'B-CTRL-14',
    text: 'Inventarisierung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-15-CRIT-01',
    controlId: 'B-CTRL-15',
    text: 'Schleusen oder Mantraps sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-15-CRIT-02',
    controlId: 'B-CTRL-15',
    text: 'Vereinzelung ist umgesetzt',
  ),
  ChecklistCriterion(
    criteriaId: 'B-CTRL-15-CRIT-03',
    controlId: 'B-CTRL-15',
    text: 'Tailgating wird erkannt oder verhindert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-03-CRIT-01',
    controlId: 'C-CTRL-03',
    text: 'Eskalationskette ist definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-03-CRIT-02',
    controlId: 'C-CTRL-03',
    text: 'Rollen sind zugeordnet',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-03-CRIT-03',
    controlId: 'C-CTRL-03',
    text: 'Alarmweiterleitung erfolgt zeitnah',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-06-CRIT-01',
    controlId: 'C-CTRL-06',
    text: 'Wartungsfenster sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-06-CRIT-02',
    controlId: 'C-CTRL-06',
    text: 'Abhängigkeiten werden berücksichtigt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-06-CRIT-03',
    controlId: 'C-CTRL-06',
    text: 'Freigaben sind geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-07-CRIT-01',
    controlId: 'C-CTRL-07',
    text: 'Auslastung wird überwacht',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-07-CRIT-02',
    controlId: 'C-CTRL-07',
    text: 'Kapazitäten sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-07-CRIT-03',
    controlId: 'C-CTRL-07',
    text: 'Reviews erfolgen regelmäßig',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-08-CRIT-01',
    controlId: 'C-CTRL-08',
    text: 'Schwellenwerte sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-08-CRIT-02',
    controlId: 'C-CTRL-08',
    text: 'Reserveanteile sind festgelegt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-08-CRIT-03',
    controlId: 'C-CTRL-08',
    text: 'Maximalbelegung ist geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-09-CRIT-01',
    controlId: 'C-CTRL-09',
    text: 'Forecasting ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-09-CRIT-02',
    controlId: 'C-CTRL-09',
    text: 'Wachstum wird berücksichtigt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-09-CRIT-03',
    controlId: 'C-CTRL-09',
    text: 'Freigabeprozesse sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-10-CRIT-01',
    controlId: 'C-CTRL-10',
    text: 'Dokumentation ist aktuell',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-10-CRIT-02',
    controlId: 'C-CTRL-10',
    text: 'Versionierung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-10-CRIT-03',
    controlId: 'C-CTRL-10',
    text: 'Relevante Rollen haben Zugriff',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-11-CRIT-01',
    controlId: 'C-CTRL-11',
    text: 'Bestandsdaten sind konsistent',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-11-CRIT-02',
    controlId: 'C-CTRL-11',
    text: 'Konfigurationsdaten sind gepflegt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-11-CRIT-03',
    controlId: 'C-CTRL-11',
    text: 'Zuordnungen sind nachvollziehbar',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-12-CRIT-01',
    controlId: 'C-CTRL-12',
    text: 'KPIs sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-12-CRIT-02',
    controlId: 'C-CTRL-12',
    text: 'Stabilität wird gemessen',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-12-CRIT-03',
    controlId: 'C-CTRL-12',
    text: 'Prozessqualität wird bewertet',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-13-CRIT-01',
    controlId: 'C-CTRL-13',
    text: 'KPIs werden ausgewertet',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-13-CRIT-02',
    controlId: 'C-CTRL-13',
    text: 'Maßnahmen werden abgeleitet',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-13-CRIT-03',
    controlId: 'C-CTRL-13',
    text: 'Nachverfolgung ist geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-14-CRIT-01',
    controlId: 'C-CTRL-14',
    text: 'Leistungsanforderungen sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-14-CRIT-02',
    controlId: 'C-CTRL-14',
    text: 'Reaktionszeiten sind festgelegt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-14-CRIT-03',
    controlId: 'C-CTRL-14',
    text: 'SLAs oder OLAs sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-15-CRIT-01',
    controlId: 'C-CTRL-15',
    text: 'Zugriffe sind kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-15-CRIT-02',
    controlId: 'C-CTRL-15',
    text: 'Tätigkeiten sind terminiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-15-CRIT-03',
    controlId: 'C-CTRL-15',
    text: 'Übergaben und Abnahmen sind geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-16-CRIT-01',
    controlId: 'C-CTRL-16',
    text: 'Reviews finden regelmäßig statt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-16-CRIT-02',
    controlId: 'C-CTRL-16',
    text: 'SLA-Abweichungen werden adressiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-16-CRIT-03',
    controlId: 'C-CTRL-16',
    text: 'Maßnahmen werden verfolgt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-17-CRIT-01',
    controlId: 'C-CTRL-17',
    text: 'Patch-Management ist definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-17-CRIT-02',
    controlId: 'C-CTRL-17',
    text: 'Firmware-Stände werden gepflegt',
  ),
  ChecklistCriterion(
    criteriaId: 'C-CTRL-17-CRIT-03',
    controlId: 'C-CTRL-17',
    text: 'Wartungsfenster sind risikobasiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-02-CRIT-01',
    controlId: 'D-CTRL-02',
    text: 'Failover-Mechanismen sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-02-CRIT-02',
    controlId: 'D-CTRL-02',
    text: 'Routing reagiert auf Ausfälle',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-02-CRIT-03',
    controlId: 'D-CTRL-02',
    text: 'Verfügbarkeitsziele werden eingehalten',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-03-CRIT-01',
    controlId: 'D-CTRL-03',
    text: 'Unterschiedliche Provider werden genutzt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-03-CRIT-02',
    controlId: 'D-CTRL-03',
    text: 'Trassen sind divers ausgelegt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-03-CRIT-03',
    controlId: 'D-CTRL-03',
    text: 'Gemeinsame Ausfallursachen sind minimiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-05-CRIT-01',
    controlId: 'D-CTRL-05',
    text: 'Gerätedefekte werden abgefangen',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-05-CRIT-02',
    controlId: 'D-CTRL-05',
    text: 'Link-Ausfälle werden abgefangen',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-05-CRIT-03',
    controlId: 'D-CTRL-05',
    text: 'Failover ist kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-06-CRIT-01',
    controlId: 'D-CTRL-06',
    text: 'Diagramme sind aktuell',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-06-CRIT-02',
    controlId: 'D-CTRL-06',
    text: 'Abhängigkeiten sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-06-CRIT-03',
    controlId: 'D-CTRL-06',
    text: 'Änderungen werden nachgeführt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-08-CRIT-01',
    controlId: 'D-CTRL-08',
    text: 'Firewalls oder ACLs sichern Übergänge',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-08-CRIT-02',
    controlId: 'D-CTRL-08',
    text: 'Deny-by-default ist umgesetzt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-08-CRIT-03',
    controlId: 'D-CTRL-08',
    text: 'Freigaben sind explizit definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-09-CRIT-01',
    controlId: 'D-CTRL-09',
    text: 'Managementnetz ist getrennt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-09-CRIT-02',
    controlId: 'D-CTRL-09',
    text: 'Starke Authentisierung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-09-CRIT-03',
    controlId: 'D-CTRL-09',
    text: 'Administrative Zugriffe sind kontrolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-10-CRIT-01',
    controlId: 'D-CTRL-10',
    text: 'Bezeichnungen sind eindeutig',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-10-CRIT-02',
    controlId: 'D-CTRL-10',
    text: 'Kennzeichnung ist konsistent',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-10-CRIT-03',
    controlId: 'D-CTRL-10',
    text: 'End-to-end-Verwaltung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-11-CRIT-01',
    controlId: 'D-CTRL-11',
    text: 'Änderungen folgen dem Change-Prozess',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-11-CRIT-02',
    controlId: 'D-CTRL-11',
    text: 'Vier-Augen-Prinzip wird angewendet',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-11-CRIT-03',
    controlId: 'D-CTRL-11',
    text: 'Wartungsfenster sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-12-CRIT-01',
    controlId: 'D-CTRL-12',
    text: 'Physische Wegführung wird berücksichtigt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-12-CRIT-02',
    controlId: 'D-CTRL-12',
    text: 'Abhängigkeiten werden geprüft',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-12-CRIT-03',
    controlId: 'D-CTRL-12',
    text: 'Gemeinsame Ausfallursachen werden vermieden',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-13-CRIT-01',
    controlId: 'D-CTRL-13',
    text: 'OOB-Netz ist getrennt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-13-CRIT-02',
    controlId: 'D-CTRL-13',
    text: 'OOB-Zugriff ist unabhängig',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-13-CRIT-03',
    controlId: 'D-CTRL-13',
    text: 'Administrative Maßnahmen bleiben möglich',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-14-CRIT-01',
    controlId: 'D-CTRL-14',
    text: 'Starke Authentisierung ist umgesetzt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-14-CRIT-02',
    controlId: 'D-CTRL-14',
    text: 'Berechtigungen sind restriktiv',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-14-CRIT-03',
    controlId: 'D-CTRL-14',
    text: 'Zugriffe werden protokolliert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-15-CRIT-01',
    controlId: 'D-CTRL-15',
    text: 'Aktivierung ist definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-15-CRIT-02',
    controlId: 'D-CTRL-15',
    text: 'Zugriffe sind zeitlich begrenzt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-15-CRIT-03',
    controlId: 'D-CTRL-15',
    text: 'Nachgelagerte Überprüfung ist geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-16-CRIT-01',
    controlId: 'D-CTRL-16',
    text: 'Konfigurationssicherungen sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-16-CRIT-02',
    controlId: 'D-CTRL-16',
    text: 'Versionierung ist umgesetzt',
  ),
  ChecklistCriterion(
    criteriaId: 'D-CTRL-16-CRIT-03',
    controlId: 'D-CTRL-16',
    text: 'Restore-Prozess ist definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-02-CRIT-01',
    controlId: 'E-CTRL-02',
    text: 'Rollen sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-02-CRIT-02',
    controlId: 'E-CTRL-02',
    text: 'Vertretungen sind geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-02-CRIT-03',
    controlId: 'E-CTRL-02',
    text: 'Kontaktlisten sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-03-CRIT-01',
    controlId: 'E-CTRL-03',
    text: 'Trigger-Kriterien sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-03-CRIT-02',
    controlId: 'E-CTRL-03',
    text: 'Übergänge in den Notbetrieb sind geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-03-CRIT-03',
    controlId: 'E-CTRL-03',
    text: 'Schnittstellen sind abgestimmt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-05-CRIT-01',
    controlId: 'E-CTRL-05',
    text: 'Wiederherstellungsumgebung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-05-CRIT-02',
    controlId: 'E-CTRL-05',
    text: 'Datenwiederherstellung ist möglich',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-05-CRIT-03',
    controlId: 'E-CTRL-05',
    text: 'Abhängigkeiten sind berücksichtigt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-07-CRIT-01',
    controlId: 'E-CTRL-07',
    text: 'RTO-Ziele sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-07-CRIT-02',
    controlId: 'E-CTRL-07',
    text: 'RPO-Ziele sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-07-CRIT-03',
    controlId: 'E-CTRL-07',
    text: 'Priorisierung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-08-CRIT-01',
    controlId: 'E-CTRL-08',
    text: 'Abhängigkeiten sind berücksichtigt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-08-CRIT-02',
    controlId: 'E-CTRL-08',
    text: 'Ziele sind abgestimmt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-08-CRIT-03',
    controlId: 'E-CTRL-08',
    text: 'Gesamtzielbild ist umsetzbar',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-09-CRIT-01',
    controlId: 'E-CTRL-09',
    text: 'Relevante Szenarien sind abgedeckt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-09-CRIT-02',
    controlId: 'E-CTRL-09',
    text: 'Notbetriebspläne sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-09-CRIT-03',
    controlId: 'E-CTRL-09',
    text: 'Kritische Funktionen sind berücksichtigt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-10-CRIT-01',
    controlId: 'E-CTRL-10',
    text: 'Abläufe sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-10-CRIT-02',
    controlId: 'E-CTRL-10',
    text: 'Rollen und Reihenfolgen sind festgelegt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-10-CRIT-03',
    controlId: 'E-CTRL-10',
    text: 'Übergangskriterien sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-11-CRIT-01',
    controlId: 'E-CTRL-11',
    text: 'Versionierung ist vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-11-CRIT-02',
    controlId: 'E-CTRL-11',
    text: 'Änderungen führen zu Updates',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-11-CRIT-03',
    controlId: 'E-CTRL-11',
    text: 'Review-Zyklen sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-12-CRIT-01',
    controlId: 'E-CTRL-12',
    text: 'Eskalationskriterien sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-12-CRIT-02',
    controlId: 'E-CTRL-12',
    text: 'Eskalationswege sind dokumentiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-12-CRIT-03',
    controlId: 'E-CTRL-12',
    text: 'Entscheidungsniveaus sind klar geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-13-CRIT-01',
    controlId: 'E-CTRL-13',
    text: 'Kommunikationsprozesse sind definiert',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-13-CRIT-02',
    controlId: 'E-CTRL-13',
    text: 'Interne Kommunikation ist geregelt',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-13-CRIT-03',
    controlId: 'E-CTRL-13',
    text: 'Externe Kommunikation ist freigegeben',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-14-CRIT-01',
    controlId: 'E-CTRL-14',
    text: 'Backups sind vorhanden',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-14-CRIT-02',
    controlId: 'E-CTRL-14',
    text: 'Restore ist getestet',
  ),
  ChecklistCriterion(
    criteriaId: 'E-CTRL-14-CRIT-03',
    controlId: 'E-CTRL-14',
    text: 'RPO-Ziele werden unterstützt',
  ),
];

List<ChecklistItem> buildChecklistTemplateFromCatalog() {
  final domainById = <String, ChecklistDomain>{
    for (final domain in domains) domain.domainId: domain,
  };
  final criteriaByControlId = <String, List<String>>{};

  for (final criterion in criteria) {
    criteriaByControlId
        .putIfAbsent(criterion.controlId, () => <String>[])
        .add(criterion.text);
  }

  return controls.map(
    (control) {
      final domain = domainById[control.domainId];
      final anchorCriteria = controlAnchorCriteria[control.controlId];
      return ChecklistItem(
        id: control.controlId,
        domainId: control.domainId,
        domainName: domain?.name ?? control.domainId,
        domainDescription: domain?.description ?? '',
        title: control.title,
        description: control.description,
        riskLevel: control.criticality,
        scoringModel: control.scoringModel,
        criteria: List<String>.from(
            criteriaByControlId[control.controlId] ?? const <String>[]),
        anchorCriteria: <int, List<String>>{
          for (final entry
              in (anchorCriteria ?? const <int, List<String>>{}).entries)
            entry.key: List<String>.from(entry.value),
        },
      );
    },
  ).toList(growable: false);
}
