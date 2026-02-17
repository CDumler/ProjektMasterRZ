import 'package:flutter_test/flutter_test.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';
import 'package:rz_checkliste_risikoanalyse/domain/services/audit_chain_service.dart';

void main() {
  test('verifies valid hash chain and fails on tamper', () {
    const service = AuditChainService();
    final t = DateTime.parse('2026-01-01T00:00:00Z');

    final e1Draft = AuditLogEntry(
      id: '1',
      timestamp: t,
      actor: 'user',
      eventType: AuditEventType.create,
      entityType: EntityType.assessment,
      entityId: 'asm-1',
      afterJson: '{"name":"A"}',
      chainHashPrev: null,
    );
    final h1 = service.computeHash(e1Draft);
    final e1 = AuditLogEntry(
      id: e1Draft.id,
      timestamp: e1Draft.timestamp,
      actor: e1Draft.actor,
      eventType: e1Draft.eventType,
      entityType: e1Draft.entityType,
      entityId: e1Draft.entityId,
      afterJson: e1Draft.afterJson,
      chainHashPrev: null,
      chainHashThis: h1,
    );

    final e2Draft = AuditLogEntry(
      id: '2',
      timestamp: t.add(const Duration(minutes: 1)),
      actor: 'user',
      eventType: AuditEventType.update,
      entityType: EntityType.assessment,
      entityId: 'asm-1',
      beforeJson: '{"status":"draft"}',
      afterJson: '{"status":"completed"}',
      chainHashPrev: h1,
    );
    final h2 = service.computeHash(e2Draft, prevHash: h1);
    final e2 = AuditLogEntry(
      id: e2Draft.id,
      timestamp: e2Draft.timestamp,
      actor: e2Draft.actor,
      eventType: e2Draft.eventType,
      entityType: e2Draft.entityType,
      entityId: e2Draft.entityId,
      beforeJson: e2Draft.beforeJson,
      afterJson: e2Draft.afterJson,
      chainHashPrev: h1,
      chainHashThis: h2,
    );

    expect(service.verifyChain([e1, e2]), isTrue);

    final tampered = AuditLogEntry(
      id: e2.id,
      timestamp: e2.timestamp,
      actor: e2.actor,
      eventType: e2.eventType,
      entityType: e2.entityType,
      entityId: e2.entityId,
      beforeJson: e2.beforeJson,
      afterJson: '{"status":"tampered"}',
      chainHashPrev: e2.chainHashPrev,
      chainHashThis: e2.chainHashThis,
    );

    expect(service.verifyChain([e1, tampered]), isFalse);
  });
}
