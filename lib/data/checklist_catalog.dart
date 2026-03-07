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
    required this.mandatory,
  });

  final String controlId;
  final String domainId;
  final String title;
  final String description;
  final int criticality;
  final bool mandatory;
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
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-02',
    domainId: 'A',
    title: 'USV-Kapazität und Autonomie',
    description:
        'Sicherstellung ausreichender USV-Leistung und definierter Überbrückungszeit.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-03',
    domainId: 'A',
    title: 'Notstromversorgung',
    description:
        'Versorgung kritischer IT-Lasten durch Generatoren bei Netzausfall.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-04',
    domainId: 'A',
    title: 'Energie-Failover-Tests',
    description:
        'Regelmäßige Tests der Umschalt- und Failover-Mechanismen der Energieversorgung.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-05',
    domainId: 'A',
    title: 'Redundante Kühlung',
    description:
        'Kühlarchitektur toleriert Ausfall einzelner Komponenten ohne kritische Temperaturüberschreitung.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-06',
    domainId: 'A',
    title: 'Luftführungskonzept',
    description:
        'Strukturierte Luftführung zur Vermeidung von Hotspots und Luftvermischung.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-07',
    domainId: 'A',
    title: 'Kühlkapazitätsplanung',
    description:
        'Dokumentierte Kühlkapazität und regelmäßige Überprüfung der Auslegungsannahmen.',
    criticality: 3,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-08',
    domainId: 'A',
    title: 'Branddetektion',
    description: 'Frühzeitige Branddetektion in allen kritischen IT-Bereichen.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-09',
    domainId: 'A',
    title: 'Löschsysteme',
    description:
        'IT-geeignete, zonierte Löschsysteme mit kontrollierten Auslösemechanismen.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-10',
    domainId: 'A',
    title: 'Wartung Brandschutzsysteme',
    description:
        'Regelmäßige Wartung und Prüfung von Branddetektion und Löschanlagen.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-11',
    domainId: 'A',
    title: 'Schutz vor Wasserschäden',
    description: 'Minimierung von Wasser- und Leckagerisiken im IT-Bereich.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-12',
    domainId: 'A',
    title: 'Bauliche Infrastruktur',
    description:
        'Bauliche Ausführung unterstützt sicheren und stabilen IT-Betrieb.',
    criticality: 3,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-13',
    domainId: 'A',
    title: 'Gebäudetechnische Risiken',
    description:
        'Bewertung und Absicherung gebäudetechnischer Schnittstellen zum IT-Bereich.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'A-CTRL-17',
    domainId: 'A',
    title: 'Umgebungsparameter',
    description:
        'Definition und Überwachung relevanter Umgebungsparameter im IT-Bereich.',
    criticality: 2,
    mandatory: false,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-01',
    domainId: 'B',
    title: 'Zutrittskontrolle',
    description:
        'Zugang zu Rechenzentrumszonen ausschließlich über autorisierte Berechtigungen.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-02',
    domainId: 'B',
    title: 'Zutrittsauthentisierung',
    description:
        'Authentisierung entsprechend dem Schutzbedarf der jeweiligen Zone.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-03',
    domainId: 'B',
    title: 'Zutrittsrechte-Lifecycle',
    description:
        'Verwaltung von Zutrittsrechten über ihren gesamten Lebenszyklus.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-07',
    domainId: 'B',
    title: 'Videoüberwachung',
    description:
        'Überwachung kritischer Bereiche zur Detektion sicherheitsrelevanter Ereignisse.',
    criticality: 3,
    mandatory: false,
  ),
  ChecklistControl(
    controlId: 'B-CTRL-10',
    domainId: 'B',
    title: 'Besucher- und Fremdfirmenprozesse',
    description:
        'Kontrolle und Dokumentation von Besuchern und externen Dienstleistern.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-01',
    domainId: 'C',
    title: 'Infrastrukturmonitoring',
    description:
        'Zentrale Überwachung kritischer Infrastruktur- und Betriebsparameter.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-02',
    domainId: 'C',
    title: 'Alarmmanagement',
    description:
        'Definierte Alarmregeln, Schwellwerte und Eskalationsmechanismen.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-04',
    domainId: 'C',
    title: 'Incident Management',
    description: 'Strukturierte Behandlung und Nachverfolgung von Störungen.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'C-CTRL-05',
    domainId: 'C',
    title: 'Change Management',
    description: 'Kontrollierte Planung und Umsetzung technischer Änderungen.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-01',
    domainId: 'D',
    title: 'WAN-Redundanz',
    description:
        'Redundante externe Netzwerkanbindungen über unabhängige Provider.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-04',
    domainId: 'D',
    title: 'Redundante Netzwerktopologie',
    description:
        'Redundante Netzwerkkomponenten und Pfade ohne Single Points of Failure.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'D-CTRL-07',
    domainId: 'D',
    title: 'Netzwerksegmentierung',
    description: 'Segmentierung und Absicherung von Netzwerkzonen.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-01',
    domainId: 'E',
    title: 'BCM Governance',
    description:
        'Klare Verantwortlichkeiten und organisatorische Struktur für Business Continuity.',
    criticality: 4,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-04',
    domainId: 'E',
    title: 'Disaster-Recovery-Strategie',
    description:
        'Definierte Strategie zur Wiederherstellung kritischer IT-Services.',
    criticality: 5,
    mandatory: true,
  ),
  ChecklistControl(
    controlId: 'E-CTRL-06',
    domainId: 'E',
    title: 'Disaster-Recovery-Tests',
    description:
        'Regelmäßige Tests der Wiederherstellungs- und Failover-Fähigkeiten.',
    criticality: 4,
    mandatory: true,
  ),
];

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
      return ChecklistItem(
        id: control.controlId,
        domainId: control.domainId,
        domainName: domain?.name ?? control.domainId,
        domainDescription: domain?.description ?? '',
        title: control.title,
        description: control.description,
        riskLevel: control.criticality,
        isMandatory: control.mandatory,
        criteria: List<String>.from(
            criteriaByControlId[control.controlId] ?? const <String>[]),
      );
    },
  ).toList(growable: false);
}
