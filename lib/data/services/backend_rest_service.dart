import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rz_checkliste_risikoanalyse/data/services/backend_api_config.dart';
import 'package:rz_checkliste_risikoanalyse/models/checklist_item.dart';

class BackendApiException implements Exception {
  const BackendApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() {
    if (statusCode == null) {
      return message;
    }
    return '[$statusCode] $message';
  }
}

class BackendUser {
  const BackendUser({
    required this.id,
    required this.email,
    required this.displayPrename,
    required this.displayName,
    required this.company,
    required this.address,
    this.createdAt,
  });

  final String id;
  final String email;
  final String displayPrename;
  final String displayName;
  final String company;
  final String address;
  final DateTime? createdAt;

  factory BackendUser.fromJson(Map<String, dynamic> json) {
    return BackendUser(
      id: _asString(json['id']),
      email: _asString(json['email']).toLowerCase(),
      displayPrename: _asString(json['display_prename']),
      displayName: _asString(json['display_name']),
      company: _asString(json['company']),
      address: _asString(json['address']),
      createdAt: _asDateTimeNullable(json['created_at']),
    );
  }
}

class BackendAssessmentSummary {
  const BackendAssessmentSummary({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    required this.itemCount,
  });

  final String id;
  final String name;
  final String createdBy;
  final String status;
  final DateTime createdAt;
  final int itemCount;

  factory BackendAssessmentSummary.fromJson(Map<String, dynamic> json) {
    return BackendAssessmentSummary(
      id: _asString(json['id']),
      name: _asString(json['name']),
      createdBy: _asString(json['created_by']),
      status: _asString(json['status']),
      createdAt: _asDateTime(json['created_at']),
      itemCount: _asInt(json['item_count']),
    );
  }
}

class BackendAssessmentItemState {
  const BackendAssessmentItemState({
    required this.id,
    required this.assessmentId,
    required this.controlId,
    required this.fulfilmentLevel,
    required this.hasAssessment,
    required this.note,
    required this.scoringModel,
    required this.riskLevel,
    this.updatedAt,
  });

  final String id;
  final String assessmentId;
  final String controlId;
  final int fulfilmentLevel;
  final bool hasAssessment;
  final String note;
  final String scoringModel;
  final int riskLevel;
  final DateTime? updatedAt;

  factory BackendAssessmentItemState.fromJson(Map<String, dynamic> json) {
    return BackendAssessmentItemState(
      id: _asString(json['id']),
      assessmentId: _asString(json['assessment_id']),
      controlId: _asString(json['control_id']),
      fulfilmentLevel: _asInt(json['fulfilment_level']),
      hasAssessment: _asBool(json['has_assessment']),
      note: _asString(json['note']),
      scoringModel: _asString(json['scoring_model']).toLowerCase(),
      riskLevel: _asInt(json['risk_level']),
      updatedAt: _asDateTimeNullable(json['updated_at']),
    );
  }
}

class BackendAssessment {
  const BackendAssessment({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  final String id;
  final String name;
  final String createdBy;
  final String status;
  final DateTime createdAt;
  final List<BackendAssessmentItemState> items;

  factory BackendAssessment.fromJson(Map<String, dynamic> json) {
    final itemsJson = _asList(json['items']);
    return BackendAssessment(
      id: _asString(json['id']),
      name: _asString(json['name']),
      createdBy: _asString(json['created_by']),
      status: _asString(json['status']),
      createdAt: _asDateTime(json['created_at']),
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(BackendAssessmentItemState.fromJson)
          .toList(growable: false),
    );
  }
}

class BackendRestService {
  BackendRestService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  bool get isEnabled => BackendApiConfig.isEnabled;

  Future<BackendUser> register({
    required String email,
    required String password,
    String displayPrename = '',
    String displayName = '',
    String company = '',
    String address = '',
  }) async {
    _ensureEnabled();
    final data = await _request(
      method: 'POST',
      path: '/auth_register.php',
      body: <String, dynamic>{
        'email': email.trim().toLowerCase(),
        'password': password,
        'display_prename': displayPrename.trim(),
        'display_name': displayName.trim(),
        'company': company.trim(),
        'address': address.trim(),
      },
    );
    final payload = _unwrapEntity(data, 'user');
    return BackendUser.fromJson(payload);
  }

  Future<BackendUser> login({
    required String email,
    required String password,
  }) async {
    _ensureEnabled();
    final data = await _request(
      method: 'POST',
      path: '/auth_login.php',
      body: <String, dynamic>{
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );
    final payload = _unwrapEntity(data, 'user');
    return BackendUser.fromJson(payload);
  }

  Future<BackendUser> updateUser({
    required String userId,
    required String email,
    required String displayPrename,
    required String displayName,
    required String company,
    required String address,
    String? password,
  }) async {
    _ensureEnabled();
    final body = <String, dynamic>{
      'email': email.trim().toLowerCase(),
      'display_prename': displayPrename.trim(),
      'display_name': displayName.trim(),
      'company': company.trim(),
      'address': address.trim(),
    };
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final data = await _request(
      method: 'PUT',
      path: '/user_update.php',
      query: <String, String>{
        'id': userId,
      },
      body: body,
    );
    final payload = _unwrapEntity(data, 'user');
    return BackendUser.fromJson(payload);
  }

  Future<BackendAssessmentSummary> createAssessment({
    required String name,
    required String createdBy,
    String status = 'in_progress',
  }) async {
    _ensureEnabled();
    final data = await _request(
      method: 'POST',
      path: '/assessments_create.php',
      body: <String, dynamic>{
        'name': name.trim(),
        'created_by': createdBy,
        'status': status,
      },
    );
    final payload = _unwrapEntity(data, 'assessment');
    return BackendAssessmentSummary.fromJson(payload);
  }

  Future<List<BackendAssessmentSummary>> listAssessments({
    required String createdBy,
  }) async {
    _ensureEnabled();
    final data = await _request(
      method: 'GET',
      path: '/assessments_list.php',
      query: <String, String>{'created_by': createdBy},
    );

    final rows = _asList(data['assessments']);
    return rows
        .whereType<Map<String, dynamic>>()
        .map(BackendAssessmentSummary.fromJson)
        .toList(growable: false);
  }

  Future<void> deleteAssessments({
    required List<String> assessmentIds,
    required String createdBy,
  }) async {
    _ensureEnabled();
    if (assessmentIds.isEmpty) {
      return;
    }

    await _request(
      method: 'DELETE',
      path: '/assessments_delete.php',
      body: <String, dynamic>{
        'ids': assessmentIds,
        'created_by': createdBy,
      },
    );
  }

  Future<BackendAssessment> getAssessment({
    required String assessmentId,
  }) async {
    _ensureEnabled();
    final data = await _request(
      method: 'GET',
      path: '/assessment_get.php',
      query: <String, String>{
        'id': assessmentId,
      },
    );

    final assessmentPayload = _unwrapEntity(data, 'assessment');
    final items = _asList(data['items'])
        .whereType<Map<String, dynamic>>()
        .map(BackendAssessmentItemState.fromJson)
        .toList(growable: false);

    final merged = <String, dynamic>{
      ...assessmentPayload,
      'items': items.map(_itemToJson).toList(growable: false),
    };

    return BackendAssessment.fromJson(merged);
  }

  Future<void> upsertAssessmentItem({
    required String assessmentId,
    required ChecklistItem item,
  }) async {
    _ensureEnabled();
    await _request(
      method: 'PUT',
      path: '/assessment_item_upsert.php',
      query: <String, String>{
        'assessment_id': assessmentId,
        'control_id': item.id,
      },
      body: _itemPayload(item),
    );
  }

  Future<void> upsertAssessmentItemsBatch({
    required String assessmentId,
    required List<ChecklistItem> items,
  }) async {
    _ensureEnabled();
    await _request(
      method: 'POST',
      path: '/assessment_items_batch_upsert.php',
      query: <String, String>{
        'assessment_id': assessmentId,
      },
      body: <String, dynamic>{
        'items': items.map(_itemPayload).toList(growable: false),
      },
    );
  }

  Map<String, dynamic> _itemPayload(ChecklistItem item) {
    return <String, dynamic>{
      'control_id': item.id,
      'fulfilment_level': item.fulfilmentLevel,
      'has_assessment': item.hasAssessment ? 1 : 0,
      'note': item.note,
      'scoring_model': item.scoringModel.name,
      'risk_level': item.riskLevel,
    };
  }

  Future<Map<String, dynamic>> _request({
    required String method,
    required String path,
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final base = BackendApiConfig.baseUrl.trim();
    final normalizedBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBase$normalizedPath')
        .replace(queryParameters: query);

    http.Response response;
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final encodedBody = body == null ? null : jsonEncode(body);

    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(uri, headers: headers, body: encodedBody);
        break;
      case 'PUT':
        response = await _client.put(uri, headers: headers, body: encodedBody);
        break;
      case 'DELETE':
        response =
            await _client.delete(uri, headers: headers, body: encodedBody);
        break;
      default:
        throw BackendApiException('HTTP-Methode nicht unterstützt: $method');
    }

    final status = response.statusCode;
    Map<String, dynamic> payload = <String, dynamic>{};
    if (response.body.trim().isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        payload = decoded;
      }
    }

    if (status < 200 || status >= 300) {
      final message = _asString(payload['message']).trim();
      throw BackendApiException(
        message.isEmpty ? 'Backend-Fehler ($status)' : message,
        statusCode: status,
      );
    }

    return payload;
  }

  void _ensureEnabled() {
    if (!isEnabled) {
      throw const BackendApiException(
        'API_BASE_URL ist nicht gesetzt. Backend-Modus ist nicht aktiv.',
      );
    }
  }
}

Map<String, dynamic> _unwrapEntity(Map<String, dynamic> data, String key) {
  final raw = data[key];
  if (raw is Map<String, dynamic>) {
    return raw;
  }
  return data;
}

Map<String, dynamic> _itemToJson(BackendAssessmentItemState item) {
  return <String, dynamic>{
    'id': item.id,
    'assessment_id': item.assessmentId,
    'control_id': item.controlId,
    'fulfilment_level': item.fulfilmentLevel,
    'has_assessment': item.hasAssessment ? 1 : 0,
    'note': item.note,
    'scoring_model': item.scoringModel,
    'risk_level': item.riskLevel,
    'updated_at': item.updatedAt?.toIso8601String(),
  };
}

List<dynamic> _asList(dynamic value) {
  if (value is List) {
    return value;
  }
  return <dynamic>[];
}

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }
  return value.toString();
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null) {
      return parsed;
    }
  }
  return fallback;
}

bool _asBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == '1' || normalized == 'true' || normalized == 'yes';
  }
  return false;
}

DateTime _asDateTime(dynamic value) {
  final maybe = _asDateTimeNullable(value);
  if (maybe != null) {
    return maybe;
  }
  return DateTime.now();
}

DateTime? _asDateTimeNullable(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  if (text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}
