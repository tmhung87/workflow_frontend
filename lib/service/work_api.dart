import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:workflow/models/work.dart';

class WorkApiService {
  static final String _baseUrl =
      dotenv.env['URL'] ?? 'http://localhost:3000/api';
  static final _storage = FlutterSecureStorage();

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  static Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Get all works
  static Future<Map<String, dynamic>> getWork() async {
    final response = await http.get(Uri.parse('$_baseUrl/work'));
    return jsonDecode(response.body);
  }

  // Get work by ID
  static Future<Map<String, dynamic>> getWorkById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/work/$id'));
    return jsonDecode(response.body);
  }

  // Update a work
  static Future<Map<String, dynamic>> updateWork(Work work) async {
    final token = await _getToken();
    if (token == null) return {'state': false, 'message': 'Token not found'};

    final response = await http.put(
      Uri.parse('$_baseUrl/work/update'),
      headers: _headers(token),
      body: jsonEncode(work.toJson()),
    );

    return jsonDecode(response.body);
  }

  // Delete a work
  static Future<Map<String, dynamic>> deleteWork(int id) async {
    final token = await _getToken();
    if (token == null) return {'state': false, 'message': 'Token not found'};

    final response = await http.delete(
      Uri.parse('$_baseUrl/work/$id'),
      headers: _headers(token),
    );

    return jsonDecode(response.body);
  }

  // Create a new work
  static Future<Map<String, dynamic>> createWork(Work work) async {
    final token = await _getToken();
    if (token == null) return {'state': false, 'message': 'Token not found'};

    final response = await http.post(
      Uri.parse('$_baseUrl/work/create'),
      headers: _headers(token),
      body: jsonEncode(work.toJson()),
    );

    return jsonDecode(response.body);
  }

  // Find multiple works
  static Future<List<Work>> findWork({
    String? workId,
    String? description,
    String? title,
    String? assigned,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.post(
      Uri.parse('$_baseUrl/work/find'),
      headers: _headers(token),
      body: jsonEncode({
        'workId': workId,
        'title': title,
        'description': description,
        'assigned': assigned,
        'status': status,
        'startTime': startTime?.toUtc().toIso8601String(),
        'endTime': endTime?.toUtc().toIso8601String(),
      }),
    );

    final map = jsonDecode(response.body);
    if (map['state'] != true) return [];

    final worksList = map['works'] as List<dynamic>;
    print(worksList);
    return worksList.map((e) => Work.fromJson(e)).toList();
  }

  // Find a single work by ID
  static Future<Work?> findWorkById(String workId) async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await http.post(
      Uri.parse('$_baseUrl/work/find'),
      headers: _headers(token),
      body: jsonEncode({'workId': workId}),
    );

    final map = jsonDecode(response.body);
    if (map['state'] != true || map['works'].isEmpty) return null;

    return Work.fromJson(map['works'][0]);
  }
}
