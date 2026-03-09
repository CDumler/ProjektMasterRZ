import 'package:flutter/material.dart';
import 'package:rz_checkliste_risikoanalyse/data/checklist_catalog.dart';
import 'package:rz_checkliste_risikoanalyse/data/services/pdf_report_generator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rz_checkliste_risikoanalyse/models/assessment_record.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';
import 'package:rz_checkliste_risikoanalyse/screens/assessment_setup_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/checklist_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/existing_assessments_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/home_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/login_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/profile_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/risk_analysis_screen.dart';
import 'package:rz_checkliste_risikoanalyse/screens/welcome_screen.dart';

class _UserProfile {
  const _UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    required this.company,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String company;

  _UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? address,
    String? company,
  }) {
    return _UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      company: company ?? this.company,
    );
  }
}

class DatacenterApp extends StatefulWidget {
  const DatacenterApp({super.key});

  @override
  State<DatacenterApp> createState() => _DatacenterAppState();
}

class _DatacenterAppState extends State<DatacenterApp> {
  static const _adminEmail = 'admin@rz-checkliste.de';
  static const _adminPassword = 'Admin123!';
  static const _reportVersion = '1.0';

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final PdfReportGenerator _reportGenerator = const PdfReportGenerator();
  final Map<String, _UserProfile> _accounts = <String, _UserProfile>{
    _adminEmail: const _UserProfile(
      firstName: 'Admin',
      lastName: 'User',
      email: _adminEmail,
      password: _adminPassword,
      address: '',
      company: 'RZ Checkliste',
    ),
  };
  String? _activeUserEmail = _adminEmail;
  final List<ChecklistItem> _checklistTemplate =
      buildChecklistTemplateFromCatalog();
  final List<AssessmentRecord> _assessments = <AssessmentRecord>[];
  String? _activeAssessmentId;

  AssessmentRecord? get _activeAssessment {
    final id = _activeAssessmentId;
    if (id == null) {
      return null;
    }
    for (final assessment in _assessments) {
      if (assessment.id == id) {
        return assessment;
      }
    }
    return null;
  }

  List<ChecklistItem> get _activeItems =>
      _activeAssessment?.items ?? <ChecklistItem>[];

  _UserProfile? get _activeUserProfile {
    final email = _activeUserEmail;
    if (email == null) {
      return null;
    }
    return _accounts[email];
  }

  void _updateItem(String id, int fulfilmentLevel) {
    setState(() {
      for (final item in _activeItems) {
        if (item.id == id) {
          item.fulfilmentLevel = item.normalizeFulfilmentLevel(fulfilmentLevel);
          break;
        }
      }
    });
  }

  void _addEvidenceToItem(String id, ChecklistEvidence evidence) {
    setState(() {
      for (final item in _activeItems) {
        if (item.id == id) {
          item.evidence.add(evidence);
          break;
        }
      }
    });
  }

  void _updateItemNote(String id, String note) {
    setState(() {
      for (final item in _activeItems) {
        if (item.id == id) {
          item.note = note;
          break;
        }
      }
    });
  }

  void _openChecklist() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChecklistScreen(
          items: _activeItems,
          onItemChanged: _updateItem,
          onEvidenceAdded: _addEvidenceToItem,
          onNoteChanged: _updateItemNote,
        ),
      ),
    );
  }

  void _openRiskAnalysis() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
          builder: (_) => RiskAnalysisScreen(items: _activeItems)),
    );
  }

  void _openHome() {
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          onOpenChecklist: _openChecklist,
          onOpenRiskAnalysis: _openRiskAnalysis,
          onCompleteAssessment:
              _activeAssessment == null ? null : _generateCompletionReport,
          onBackToProfile: _openProfile,
          items: _activeItems,
          assessmentName: _activeAssessment?.name,
        ),
      ),
      (_) => false,
    );
  }

  Future<String> _generateCompletionReport() async {
    final assessment = _activeAssessment;
    if (assessment == null) {
      throw StateError('Keine aktive Prüfung vorhanden.');
    }

    final report = await _reportGenerator.generateAssessmentReport(
      assessment: assessment,
      auditor: _activeUserEmail ?? 'Unbekannt',
      reportVersion: _reportVersion,
      confidentiality: 'Internal',
    );

    return report.filePath;
  }

  void _startAssessment() {
    _openAssessmentSetup();
  }

  void _openAssessmentSetup() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AssessmentSetupScreen(
          initialItems: _checklistTemplate,
          onStartWithChecklist: (assessmentName, items) {
            setState(() {
              final newAssessment = AssessmentRecord(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                name: assessmentName,
                createdAt: DateTime.now(),
                items: items
                    .map(
                      (e) => ChecklistItem(
                        id: e.id,
                        domainId: e.domainId,
                        domainName: e.domainName,
                        domainDescription: e.domainDescription,
                        title: e.title,
                        description: e.description,
                        riskLevel: e.riskLevel,
                        scoringModel: e.scoringModel,
                        fulfilmentLevel: e.fulfilmentLevel,
                        note: '',
                        criteria: List<String>.from(e.criteria),
                        anchorCriteria: <int, List<String>>{
                          for (final entry in e.anchorCriteria.entries)
                            entry.key: List<String>.from(entry.value),
                        },
                        evidence: <ChecklistEvidence>[],
                      ),
                    )
                    .toList(growable: true),
              );
              _assessments.insert(0, newAssessment);
              _activeAssessmentId = newAssessment.id;
            });
            _openHome();
          },
        ),
      ),
    );
  }

  void _openExistingAssessments() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ExistingAssessmentsScreen(
          assessments: _assessments,
          onOpenAssessment: (assessment) {
            _activeAssessmentId = assessment.id;
            _openHome();
          },
          onDeleteAssessments: (assessmentIds) {
            setState(() {
              _assessments.removeWhere(
                  (assessment) => assessmentIds.contains(assessment.id));
              if (_activeAssessmentId != null &&
                  assessmentIds.contains(_activeAssessmentId)) {
                _activeAssessmentId = null;
              }
            });
          },
        ),
      ),
    );
  }

  void _openProfile() {
    final profile = _activeUserProfile;
    if (profile == null) {
      _openLogin();
      return;
    }

    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: profile.email,
          password: profile.password,
          address: profile.address,
          company: profile.company,
          onSaveProfile: _saveProfile,
          onStartAssessment: _startAssessment,
          onOpenExistingAssessment: _openExistingAssessments,
          onLogout: _logout,
        ),
      ),
      (_) => false,
    );
  }

  void _openLogin({bool resetStack = false}) {
    final route = MaterialPageRoute(
      builder: (_) => LoginScreen(
        onLogin: _login,
        onRegister: _register,
        onAuthenticated: _openProfile,
      ),
    );
    if (resetStack) {
      _navigatorKey.currentState?.pushAndRemoveUntil(route, (_) => false);
      return;
    }
    _navigatorKey.currentState?.push(route);
  }

  void _logout() {
    _activeUserEmail = null;
    _openLogin(resetStack: true);
  }

  Future<String?> _saveProfile(ProfileFormData data) async {
    final currentEmail = _activeUserEmail;
    if (currentEmail == null) {
      return 'Kein aktives Benutzerkonto gefunden.';
    }

    final currentProfile = _accounts[currentEmail];
    if (currentProfile == null) {
      return 'Benutzerprofil nicht gefunden.';
    }

    final normalizedEmail = data.email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      return 'Bitte E-Mail-Adresse eingeben.';
    }
    if (normalizedEmail != currentEmail &&
        _accounts.containsKey(normalizedEmail)) {
      return 'Für diese E-Mail-Adresse existiert bereits ein Konto.';
    }

    final updated = currentProfile.copyWith(
      firstName: data.firstName.trim(),
      lastName: data.lastName.trim(),
      email: normalizedEmail,
      password: data.password,
      address: data.address.trim(),
      company: data.company.trim(),
    );

    setState(() {
      if (normalizedEmail != currentEmail) {
        _accounts.remove(currentEmail);
      }
      _accounts[normalizedEmail] = updated;
      _activeUserEmail = normalizedEmail;
    });

    return null;
  }

  Future<String?> _login(String email, String password) async {
    final normalizedMail = email.toLowerCase();
    final profile = _accounts[normalizedMail];
    if (profile == null) {
      return 'Kein Konto gefunden. Bitte zuerst registrieren.';
    }
    if (profile.password != password) {
      return 'E-Mail-Adresse oder Passwort ist falsch.';
    }
    _activeUserEmail = normalizedMail;
    return null;
  }

  Future<String?> _register(
      String email, String password, String confirmPassword) async {
    final normalizedMail = email.toLowerCase();
    if (_accounts.containsKey(normalizedMail)) {
      return 'Für diese E-Mail-Adresse existiert bereits ein Konto.';
    }
    if (password != confirmPassword) {
      return 'Passwörter stimmen nicht überein.';
    }
    _accounts[normalizedMail] = _UserProfile(
      firstName: '',
      lastName: '',
      email: normalizedMail,
      password: password,
      address: '',
      company: '',
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'RZ Checkliste',
      debugShowCheckedModeBanner: false,
      locale: const Locale('de'),
      supportedLocales: const [Locale('de'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B5B57)),
      ),
      home: WelcomeScreen(
        onStart: _openProfile,
      ),
    );
  }
}
