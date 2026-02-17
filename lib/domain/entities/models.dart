import 'dart:convert';

import 'package:rz_checkliste_risikoanalyse/domain/entities/enums.dart';

class ContextProfile {
  const ContextProfile({
    required this.id,
    required this.name,
    required this.parametersJson,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String parametersJson;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'parametersJson': parametersJson,
        'createdAt': createdAt.toIso8601String(),
      };
}

class Assessment {
  const Assessment({
    required this.id,
    required this.name,
    required this.org,
    required this.location,
    required this.contextProfileId,
    required this.status,
    required this.catalogVersion,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.responsibleRole,
    this.assessmentDate,
  });

  final String id;
  final String name;
  final String org;
  final String location;
  final String contextProfileId;
  final AssessmentStatus status;
  final String catalogVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final String? responsibleRole;
  final DateTime? assessmentDate;

  Assessment copyWith({
    AssessmentStatus? status,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return Assessment(
      id: id,
      name: name,
      org: org,
      location: location,
      contextProfileId: contextProfileId,
      status: status ?? this.status,
      catalogVersion: catalogVersion,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      responsibleRole: responsibleRole,
      assessmentDate: assessmentDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'org': org,
        'location': location,
        'contextProfileId': contextProfileId,
        'status': status.name,
        'catalogVersion': catalogVersion,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'responsibleRole': responsibleRole,
        'assessmentDate': assessmentDate?.toIso8601String(),
      };
}

class DomainEntity {
  const DomainEntity({required this.id, required this.name, required this.description});

  final String id;
  final String name;
  final String description;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description};
}

class Topic {
  const Topic({required this.id, required this.domainId, required this.name});

  final String id;
  final String domainId;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'domainId': domainId, 'name': name};
}

class NormReference {
  const NormReference({
    required this.id,
    required this.standardName,
    required this.standardVersion,
    required this.refCode,
    required this.refTextShort,
  });

  final String id;
  final String standardName;
  final String standardVersion;
  final String refCode;
  final String refTextShort;

  Map<String, dynamic> toJson() => {
        'id': id,
        'standardName': standardName,
        'standardVersion': standardVersion,
        'refCode': refCode,
        'refTextShort': refTextShort,
      };
}

class ControlItem {
  const ControlItem({
    required this.id,
    required this.domainId,
    required this.topicId,
    required this.title,
    required this.objective,
    required this.question,
    required this.scoringModel,
    required this.anchorsJson,
    required this.evidenceRequirementsJson,
    required this.riskRelevant,
    required this.catalogVersion,
    required this.isActive,
  });

  final String id;
  final String domainId;
  final String topicId;
  final String title;
  final String objective;
  final String question;
  final ScoringModel scoringModel;
  final String anchorsJson;
  final String evidenceRequirementsJson;
  final bool riskRelevant;
  final String catalogVersion;
  final bool isActive;

  Map<String, dynamic> get anchors => jsonDecode(anchorsJson) as Map<String, dynamic>;

  Map<String, dynamic> get evidenceRequirements =>
      jsonDecode(evidenceRequirementsJson) as Map<String, dynamic>;

  Map<String, dynamic> toJson() => {
        'id': id,
        'domainId': domainId,
        'topicId': topicId,
        'title': title,
        'objective': objective,
        'question': question,
        'scoringModel': scoringModel.name,
        'anchorsJson': anchorsJson,
        'evidenceRequirementsJson': evidenceRequirementsJson,
        'riskRelevant': riskRelevant,
        'catalogVersion': catalogVersion,
        'isActive': isActive,
      };
}

class ItemAnswer {
  const ItemAnswer({
    required this.id,
    required this.assessmentId,
    required this.controlItemId,
    required this.scoreType,
    this.fulfilmentEnum,
    this.maturityLevel,
    required this.notes,
    required this.answeredBy,
    required this.answeredAt,
  });

  final String id;
  final String assessmentId;
  final String controlItemId;
  final ScoringModel scoreType;
  final Fulfilment? fulfilmentEnum;
  final int? maturityLevel;
  final String notes;
  final String answeredBy;
  final DateTime answeredAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'assessmentId': assessmentId,
        'controlItemId': controlItemId,
        'scoreType': scoreType.name,
        'fulfilmentEnum': fulfilmentEnum?.name,
        'maturityLevel': maturityLevel,
        'notes': notes,
        'answeredBy': answeredBy,
        'answeredAt': answeredAt.toIso8601String(),
      };
}

class Finding {
  const Finding({
    required this.id,
    required this.assessmentId,
    required this.controlItemId,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.action,
  });

  final String id;
  final String assessmentId;
  final String controlItemId;
  final String title;
  final String description;
  final FindingType type;
  final Severity severity;
  final FindingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? action;

  Map<String, dynamic> toJson() => {
        'id': id,
        'assessmentId': assessmentId,
        'controlItemId': controlItemId,
        'title': title,
        'description': description,
        'type': type.name,
        'severity': severity.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'action': action,
      };
}

class RiskRecord {
  const RiskRecord({
    required this.id,
    required this.assessmentId,
    required this.findingId,
    required this.likelihood,
    required this.impact,
    required this.score,
    required this.riskClass,
    required this.rationale,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String assessmentId;
  final String findingId;
  final int likelihood;
  final int impact;
  final int score;
  final RiskClass riskClass;
  final String rationale;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'assessmentId': assessmentId,
        'findingId': findingId,
        'likelihood': likelihood,
        'impact': impact,
        'score': score,
        'riskClass': riskClass.name,
        'rationale': rationale,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Evidence {
  const Evidence({
    required this.id,
    required this.assessmentId,
    required this.linkedEntityType,
    required this.linkedEntityId,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    this.fileHash,
    this.hashAlg,
    required this.source,
    required this.owner,
    required this.confidentiality,
    this.validUntil,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  final String id;
  final String assessmentId;
  final EntityType linkedEntityType;
  final String linkedEntityId;
  final String filePath;
  final String fileName;
  final String mimeType;
  final String? fileHash;
  final String? hashAlg;
  final String source;
  final String owner;
  final String confidentiality;
  final DateTime? validUntil;
  final EvidenceStatus status;
  final String notes;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'assessmentId': assessmentId,
        'linkedEntityType': linkedEntityType.name,
        'linkedEntityId': linkedEntityId,
        'filePath': filePath,
        'fileName': fileName,
        'mimeType': mimeType,
        'fileHash': fileHash,
        'hashAlg': hashAlg,
        'source': source,
        'owner': owner,
        'confidentiality': confidentiality,
        'validUntil': validUntil?.toIso8601String(),
        'status': status.name,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };
}

class AuditLogEntry {
  const AuditLogEntry({
    required this.id,
    required this.timestamp,
    required this.actor,
    required this.eventType,
    required this.entityType,
    required this.entityId,
    this.beforeJson,
    this.afterJson,
    this.chainHashPrev,
    this.chainHashThis,
  });

  final String id;
  final DateTime timestamp;
  final String actor;
  final AuditEventType eventType;
  final EntityType entityType;
  final String entityId;
  final String? beforeJson;
  final String? afterJson;
  final String? chainHashPrev;
  final String? chainHashThis;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'actor': actor,
        'eventType': eventType.name,
        'entityType': entityType.name,
        'entityId': entityId,
        'beforeJson': beforeJson,
        'afterJson': afterJson,
        'chainHashPrev': chainHashPrev,
        'chainHashThis': chainHashThis,
      };
}

class ScoredRisk {
  const ScoredRisk({
    required this.likelihood,
    required this.impact,
    required this.score,
    required this.riskClass,
  });

  final int likelihood;
  final int impact;
  final int score;
  final RiskClass riskClass;
}

class DomainRiskAggregate {
  const DomainRiskAggregate({
    required this.domainId,
    required this.max,
    required this.average,
  });

  final String domainId;
  final int max;
  final double average;
}
