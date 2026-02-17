import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:rz_checkliste_risikoanalyse/domain/entities/models.dart';

class AuditChainService {
  const AuditChainService();

  String computeHash(AuditLogEntry entry, {String? prevHash}) {
    final payload = jsonEncode({
      'id': entry.id,
      'timestamp': entry.timestamp.toIso8601String(),
      'actor': entry.actor,
      'eventType': entry.eventType.name,
      'entityType': entry.entityType.name,
      'entityId': entry.entityId,
      'beforeJson': entry.beforeJson,
      'afterJson': entry.afterJson,
      'prevHash': prevHash,
    });
    return sha256.convert(utf8.encode(payload)).toString();
  }

  bool verifyChain(List<AuditLogEntry> entries) {
    String? prev;
    for (final entry in entries) {
      if (entry.chainHashThis == null) {
        return false;
      }
      if (entry.chainHashPrev != prev) {
        return false;
      }
      final computed = computeHash(entry, prevHash: prev);
      if (computed != entry.chainHashThis) {
        return false;
      }
      prev = entry.chainHashThis;
    }
    return true;
  }
}
