import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rz_checkliste_risikoanalyse/data/checklist_catalog.dart';
import 'package:rz_checkliste_risikoanalyse/data/services/backend_rest_service.dart';
import 'package:rz_checkliste_risikoanalyse/data/services/pdf_report_generator.dart';
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
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    required this.company,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String company;

  _UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? address,
    String? company,
  }) {
    return _UserProfile(
      id: id ?? this.id,
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
  static const _defaultAssessmentStatus = 'in_progress';

  final BackendRestService _backendService = BackendRestService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final PdfReportGenerator _reportGenerator = const PdfReportGenerator();
  final Map<String, _UserProfile> _accounts = <String, _UserProfile>{
    _adminEmail: const _UserProfile(
      id: _adminEmail,
      firstName: 'Admin',
      lastName: 'User',
      email: _adminEmail,
      password: _adminPassword,
      address: '',
      company: 'RZ Checkliste',
    ),
  };
  final List<ChecklistItem> _checklistTemplate =
      buildChecklistTemplateFromCatalog();
  final List<AssessmentRecord> _assessments = <AssessmentRecord>[];
  final Map<String, Timer> _noteSyncDebounce = <String, Timer>{};

  _UserProfile? _activeUser;
  String? _activeAssessmentId;

  bool get _useBackend => _backendService.isEnabled;
  String? get _activeUserEmail => _activeUser?.email;
  String? get _activeUserId => _activeUser?.id;

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

  _UserProfile? get _activeUserProfile => _activeUser;

  @override
  void initState() {
    super.initState();
    if (!_useBackend) {
      _activeUser = _accounts[_adminEmail];
    }
  }

  @override
  void dispose() {
    for (final timer in _noteSyncDebounce.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _updateItem(String id, int fulfilmentLevel) {
    setState(() {
      for (final item in _activeItems) {
        if (item.id == id) {
          item.applyFulfilmentLevel(fulfilmentLevel);
          break;
        }
      }
    });
    _syncActiveAssessmentItem(id);
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
    _syncActiveAssessmentItem(id);
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
    _debounceItemSync(id);
  }

  void _debounceItemSync(String controlId) {
    if (!_useBackend) {
      return;
    }
    _noteSyncDebounce[controlId]?.cancel();
    _noteSyncDebounce[controlId] = Timer(
      const Duration(milliseconds: 700),
      () => _syncActiveAssessmentItem(controlId),
    );
  }

  Future<void> _syncActiveAssessmentItem(String controlId) async {
    if (!_useBackend) {
      return;
    }

    final assessment = _activeAssessment;
    if (assessment == null) {
      return;
    }

    ChecklistItem? item;
    for (final candidate in assessment.items) {
      if (candidate.id == controlId) {
        item = candidate;
        break;
      }
    }
    if (item == null) {
      return;
    }

    try {
      await _backendService.upsertAssessmentItem(
        assessmentId: assessment.id,
        item: item,
      );
    } catch (error) {
      debugPrint('Item-Sync fehlgeschlagen für $controlId: $error');
    }
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
        builder: (_) => RiskAnalysisScreen(items: _activeItems),
      ),
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
          onStartWithChecklist: _startWithChecklist,
        ),
      ),
    );
  }

  Future<String?> _startWithChecklist(
    String assessmentName,
    List<ChecklistItem> items,
  ) async {
    final userId = _activeUserId;
    if (userId == null || userId.trim().isEmpty) {
      return 'Kein aktiver Benutzer vorhanden.';
    }

    final preparedItems = _cloneAssessmentItems(items);

    if (_useBackend) {
      try {
        final created = await _backendService.createAssessment(
          name: assessmentName,
          createdBy: userId,
          status: _defaultAssessmentStatus,
        );

        if (preparedItems.isNotEmpty) {
          await _backendService.upsertAssessmentItemsBatch(
            assessmentId: created.id,
            items: preparedItems,
          );
        }

        setState(() {
          final record = AssessmentRecord(
            id: created.id,
            name: created.name,
            items: preparedItems,
            createdAt: created.createdAt,
            createdBy: created.createdBy,
            status: created.status,
            itemCount: preparedItems.length,
          );
          _assessments.insert(0, record);
          _activeAssessmentId = record.id;
        });
      } on BackendApiException catch (error) {
        return error.message;
      } catch (_) {
        return 'Prüfung konnte nicht erstellt werden.';
      }
    } else {
      setState(() {
        final record = AssessmentRecord(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: assessmentName,
          items: preparedItems,
          createdAt: DateTime.now(),
          createdBy: userId,
          status: _defaultAssessmentStatus,
          itemCount: preparedItems.length,
        );
        _assessments.insert(0, record);
        _activeAssessmentId = record.id;
      });
    }

    _openHome();
    return null;
  }

  List<ChecklistItem> _cloneAssessmentItems(List<ChecklistItem> items) {
    return items
        .map(
          (item) => ChecklistItem(
            id: item.id,
            domainId: item.domainId,
            domainName: item.domainName,
            domainDescription: item.domainDescription,
            title: item.title,
            description: item.description,
            riskLevel: item.riskLevel,
            scoringModel: item.scoringModel,
            fulfilmentLevel: 0,
            hasAssessment: false,
            note: '',
            criteria: List<String>.from(item.criteria),
            anchorCriteria: <int, List<String>>{
              for (final entry in item.anchorCriteria.entries)
                entry.key: List<String>.from(entry.value),
            },
            evidence: <ChecklistEvidence>[],
          ),
        )
        .toList(growable: true);
  }

  void _openExistingAssessments() {
    _openExistingAssessmentsFlow();
  }

  Future<void> _openExistingAssessmentsFlow() async {
    if (_useBackend) {
      final loadError = await _refreshAssessmentsFromBackend();
      if (loadError != null) {
        _showRootSnackbar(loadError);
        return;
      }
    }

    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ExistingAssessmentsScreen(
          assessments: _assessments,
          onOpenAssessment: _openExistingAssessment,
          onDeleteAssessments: _deleteAssessments,
        ),
      ),
    );
  }

  Future<String?> _refreshAssessmentsFromBackend() async {
    final userId = _activeUserId;
    if (userId == null || userId.trim().isEmpty) {
      return 'Kein aktiver Benutzer vorhanden.';
    }

    try {
      final summaries =
          await _backendService.listAssessments(createdBy: userId);
      final records = summaries
          .map(
            (summary) => AssessmentRecord(
              id: summary.id,
              name: summary.name,
              items: <ChecklistItem>[],
              createdAt: summary.createdAt,
              createdBy: summary.createdBy,
              status: summary.status,
              itemCount: summary.itemCount,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _assessments
          ..clear()
          ..addAll(records);
      });
      return null;
    } on BackendApiException catch (error) {
      return error.message;
    } catch (_) {
      return 'Bestehende Prüfungen konnten nicht geladen werden.';
    }
  }

  Future<String?> _openExistingAssessment(AssessmentRecord assessment) async {
    if (_useBackend) {
      try {
        final backendAssessment =
            await _backendService.getAssessment(assessmentId: assessment.id);
        final loadedItems = _mapBackendItems(backendAssessment.items);
        final mappedAssessment = AssessmentRecord(
          id: backendAssessment.id,
          name: backendAssessment.name,
          items: loadedItems,
          createdAt: backendAssessment.createdAt,
          createdBy: backendAssessment.createdBy,
          status: backendAssessment.status,
          itemCount: loadedItems.length,
        );

        setState(() {
          final index = _assessments.indexWhere((e) => e.id == assessment.id);
          if (index == -1) {
            _assessments.insert(0, mappedAssessment);
          } else {
            _assessments[index] = mappedAssessment;
          }
          _activeAssessmentId = mappedAssessment.id;
        });
      } on BackendApiException catch (error) {
        return error.message;
      } catch (_) {
        return 'Prüfung konnte nicht geöffnet werden.';
      }
    } else {
      setState(() {
        _activeAssessmentId = assessment.id;
      });
    }

    _openHome();
    return null;
  }

  List<ChecklistItem> _mapBackendItems(List<BackendAssessmentItemState> rows) {
    final templateById = <String, ChecklistItem>{
      for (final item in _checklistTemplate) item.id: item,
    };
    final domainById = <String, ChecklistDomain>{
      for (final domain in domains) domain.domainId: domain,
    };

    final items = <ChecklistItem>[];

    for (final row in rows) {
      final template = templateById[row.controlId];
      final sourceDomainId =
          template?.domainId ?? _domainIdFromControlId(row.controlId);
      final domain = domainById[sourceDomainId];
      final scoringModel = row.scoringModel.toLowerCase() == 'maturity'
          ? ChecklistScoringModel.maturity
          : (template?.scoringModel ?? ChecklistScoringModel.conformity);

      final anchorSource =
          template?.anchorCriteria.entries ?? <MapEntry<int, List<String>>>[];

      final item = ChecklistItem(
        id: row.controlId,
        domainId: sourceDomainId,
        domainName: template?.domainName ?? domain?.name ?? sourceDomainId,
        domainDescription:
            template?.domainDescription ?? domain?.description ?? '',
        title: template?.title ?? row.controlId,
        description: template?.description ?? '',
        riskLevel: template?.riskLevel ?? row.riskLevel.clamp(1, 5),
        scoringModel: scoringModel,
        fulfilmentLevel: row.fulfilmentLevel,
        hasAssessment: row.hasAssessment,
        note: row.note,
        criteria: List<String>.from(template?.criteria ?? const <String>[]),
        anchorCriteria: <int, List<String>>{
          for (final entry in anchorSource)
            entry.key: List<String>.from(entry.value),
        },
        evidence: <ChecklistEvidence>[],
      );
      item.fulfilmentLevel = item.normalizeFulfilmentLevel(row.fulfilmentLevel);
      items.add(item);
    }

    return items;
  }

  String _domainIdFromControlId(String controlId) {
    final upper = controlId.trim().toUpperCase();
    if (upper.isNotEmpty && upper[0].contains(RegExp('[A-E]'))) {
      return upper[0];
    }
    return '';
  }

  Future<String?> _deleteAssessments(List<String> assessmentIds) async {
    if (assessmentIds.isEmpty) {
      return null;
    }

    if (_useBackend) {
      final userId = _activeUserId;
      if (userId == null || userId.trim().isEmpty) {
        return 'Kein aktiver Benutzer vorhanden.';
      }
      try {
        await _backendService.deleteAssessments(
          assessmentIds: assessmentIds,
          createdBy: userId,
        );
      } on BackendApiException catch (error) {
        return error.message;
      } catch (_) {
        return 'Prüfungen konnten nicht gelöscht werden.';
      }
    }

    setState(() {
      _assessments
          .removeWhere((assessment) => assessmentIds.contains(assessment.id));
      if (_activeAssessmentId != null &&
          assessmentIds.contains(_activeAssessmentId)) {
        _activeAssessmentId = null;
      }
    });
    return null;
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
    setState(() {
      _activeUser = null;
      _activeAssessmentId = null;
      _assessments.clear();
    });
    _openLogin(resetStack: true);
  }

  Future<String?> _saveProfile(ProfileFormData data) async {
    final active = _activeUser;
    if (active == null) {
      return 'Kein aktives Benutzerkonto gefunden.';
    }

    final normalizedEmail = data.email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      return 'Bitte E-Mail-Adresse eingeben.';
    }

    if (_useBackend) {
      try {
        final updatedUser = await _backendService.updateUser(
          userId: active.id,
          email: normalizedEmail,
          displayPrename: data.firstName.trim(),
          displayName: data.lastName.trim(),
          company: data.company.trim(),
          address: data.address.trim(),
          password: data.password,
        );

        setState(() {
          _activeUser = _UserProfile(
            id: updatedUser.id,
            firstName: updatedUser.displayPrename,
            lastName: updatedUser.displayName,
            email: updatedUser.email,
            password: data.password,
            address: updatedUser.address,
            company: updatedUser.company,
          );
        });
        return null;
      } on BackendApiException catch (error) {
        return error.message;
      } catch (_) {
        return 'Profil konnte nicht gespeichert werden.';
      }
    }

    if (normalizedEmail != active.email &&
        _accounts.containsKey(normalizedEmail)) {
      return 'Für diese E-Mail-Adresse existiert bereits ein Konto.';
    }

    final updated = active.copyWith(
      firstName: data.firstName.trim(),
      lastName: data.lastName.trim(),
      email: normalizedEmail,
      password: data.password,
      address: data.address.trim(),
      company: data.company.trim(),
    );

    setState(() {
      if (normalizedEmail != active.email) {
        _accounts.remove(active.email);
      }
      _accounts[normalizedEmail] = updated;
      _activeUser = updated;
    });
    return null;
  }

  Future<String?> _login(String email, String password) async {
    final normalizedMail = email.trim().toLowerCase();
    if (normalizedMail.isEmpty || password.isEmpty) {
      return 'Bitte E-Mail-Adresse und Passwort eingeben.';
    }

    // Emergency/local login path: always available, even when backend is active.
    final localProfile = _accounts[normalizedMail];
    if (localProfile != null && localProfile.password == password) {
      setState(() {
        _activeUser = localProfile;
        _activeAssessmentId = null;
        _assessments.clear();
      });
      return null;
    }

    if (_useBackend) {
      try {
        final user = await _backendService.login(
          email: normalizedMail,
          password: password,
        );
        setState(() {
          _activeUser = _UserProfile(
            id: user.id,
            firstName: user.displayPrename,
            lastName: user.displayName,
            email: user.email,
            password: password,
            address: user.address,
            company: user.company,
          );
          _activeAssessmentId = null;
          _assessments.clear();
        });
        return null;
      } on BackendApiException catch (error) {
        return error.message;
      } catch (_) {
        return 'Anmeldung fehlgeschlagen.';
      }
    }

    final profile = _accounts[normalizedMail];
    if (profile == null) {
      return 'Kein Konto gefunden. Bitte zuerst registrieren.';
    }
    if (profile.password != password) {
      return 'E-Mail-Adresse oder Passwort ist falsch.';
    }
    setState(() {
      _activeUser = profile;
      _activeAssessmentId = null;
      _assessments.clear();
    });
    return null;
  }

  Future<String?> _register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final normalizedMail = email.trim().toLowerCase();
    if (password != confirmPassword) {
      return 'Passwörter stimmen nicht überein.';
    }
    if (normalizedMail.isEmpty) {
      return 'Bitte E-Mail-Adresse eingeben.';
    }

    if (_useBackend) {
      try {
        await _backendService.register(
          email: normalizedMail,
          password: password,
        );
        return null;
      } on BackendApiException catch (error) {
        return error.message;
      } catch (_) {
        return 'Registrierung fehlgeschlagen.';
      }
    }

    if (_accounts.containsKey(normalizedMail)) {
      return 'Für diese E-Mail-Adresse existiert bereits ein Konto.';
    }
    _accounts[normalizedMail] = _UserProfile(
      id: normalizedMail,
      firstName: '',
      lastName: '',
      email: normalizedMail,
      password: password,
      address: '',
      company: '',
    );
    return null;
  }

  void _showRootSnackbar(String message) {
    if (message.trim().isEmpty) {
      return;
    }
    final context = _navigatorKey.currentContext;
    if (context == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
