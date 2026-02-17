enum AssessmentStatus { draft, inProgress, completed }

enum ScoringModel { fulfilment, maturity }

enum Fulfilment { fulfilled, partial, notFulfilled }

enum FindingType {
  insufficientControl,
  missingEvidence,
  processDeficit,
  documentationGap,
}

enum Severity { low, medium, high, critical }

enum FindingStatus { open, inProgress, resolved, accepted }

enum RiskClass { low, medium, high, critical }

enum EvidenceStatus { valid, expired, incomplete }

enum EntityType {
  assessment,
  itemAnswer,
  finding,
  evidence,
  catalog,
  riskRecord,
}

enum AuditEventType { create, update, delete, export, statusChange }
