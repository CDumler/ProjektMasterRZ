import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/assessment_detail_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/audit_log_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/catalog_management_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/dashboard_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/domain_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/evidence_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/findings_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/item_detail_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/risks_screen.dart';
import 'package:rz_checkliste_risikoanalyse/presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>(
  (_) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
      GoRoute(
        path: '/assessment/:id',
        builder: (_, state) => AssessmentDetailScreen(assessmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/assessment/:id/domain/:domainId',
        builder: (_, state) => DomainScreen(
          assessmentId: state.pathParameters['id']!,
          domainId: state.pathParameters['domainId']!,
        ),
      ),
      GoRoute(
        path: '/assessment/:id/item/:itemId',
        builder: (_, state) => ItemDetailScreen(
          assessmentId: state.pathParameters['id']!,
          itemId: state.pathParameters['itemId']!,
        ),
      ),
      GoRoute(
        path: '/assessment/:id/findings',
        builder: (_, state) => FindingsScreen(assessmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/assessment/:id/risks',
        builder: (_, state) => RisksScreen(assessmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/assessment/:id/evidence',
        builder: (_, state) => EvidenceScreen(assessmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/assessment/:id/audit',
        builder: (_, state) => AuditLogScreen(assessmentId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/catalog', builder: (_, __) => const CatalogManagementScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  ),
);
