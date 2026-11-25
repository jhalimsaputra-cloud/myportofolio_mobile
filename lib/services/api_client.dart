import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/models/skill.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({http.Client? client, String baseUrl = apiBaseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), '');

  static const _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);
    final projects =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return projects
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: {..._jsonHeaders, 'Authorization': 'Token $token'},
      body: jsonEncode(project.toJson()),
    );
    _ensureSuccess(response);
    return Project.fromJson(_jsonObject(response));
  }

  Future<List<Skill>> getSkills() async {
    final response = await _client.get(
      _uri('/api/v1/skills/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);
    final skills = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return skills
        .map((item) => Skill.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Skill> createSkill(Skill skill, {required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/skills/'),
      headers: {..._jsonHeaders, 'Authorization': 'Token $token'},
      body: jsonEncode(skill.toJson()),
    );
    _ensureSuccess(response);
    return Skill.fromJson(_jsonObject(response));
  }

  Future<Skill> updateSkill(
    Skill original,
    Skill edited, {
    required String token,
  }) async {
    final id = original.id;
    if (id == null) throw ArgumentError('The original skill must have an ID.');
    final originalJson = original.toJson();
    final changes = edited.toJson()
      ..removeWhere((key, value) => originalJson[key] == value);
    final response = await _client.patch(
      _uri('/api/v1/skills/${Uri.encodeComponent(id)}/'),
      headers: {..._jsonHeaders, 'Authorization': 'Token $token'},
      body: jsonEncode(changes),
    );
    _ensureSuccess(response);
    return Skill.fromJson(_jsonObject(response));
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: _jsonHeaders,
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);
    return _jsonObject(response)['token'] as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );
    _ensureSuccess(response);
  }

  Map<String, dynamic> _jsonObject(http.Response response) =>
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
