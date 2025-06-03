import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EvaluateApiService {
  static final String _baseUrl =
      '${dotenv.env['URL'] ?? 'http://localhost:3000/api'}/evaluate';
  static final _storage = FlutterSecureStorage();

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  static Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Get all work hours
  static Future<List<Map<String, dynamic>>> getEvaluateStaff({
    required String staffId,
  }) async {
    print(staffId);
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/$staffId'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);
    if (data['state'] != true || data['evaluates'] == null) return [];
    final result = data['evaluates'] as List<dynamic>;
    final json = result.map((e) => (e as Map<String, dynamic>)).toList();
    return json;
  }

  static Future<List<Map<String, dynamic>>> getEvaluateDaily({
    required String staffId,
    required String name,
    required String division,
    required String department,
  }) async {
    print('$_baseUrl/daily');
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.post(
      Uri.parse('$_baseUrl/daily'),
      headers: _headers(token),
      body: jsonEncode({
        'staffId': staffId,
        'name': name,
        'division': division,
        'department': department,
      }),
    );

    final data = jsonDecode(response.body);
    if (data['state'] != true || data['evaluates'] == null) return [];
    final result = data['evaluates'] as List<dynamic>;
    final json = result.map((e) => (e as Map<String, dynamic>)).toList();
    return json;
  }

  static Future<List<Map<String, dynamic>>> getEvaluateMonthly({
    required String staffId,
    required String name,
    required String division,
    required String department,
  }) async {
    final token = await _getToken();
    if (token == null) return [];
    print('$_baseUrl/monthly');
    final response = await http.post(
      Uri.parse('$_baseUrl/monthly'),
      headers: _headers(token),
      body: jsonEncode({
        'staffId': staffId,
        'name': name,
        'division': division,
        'department': department,
      }),
    );

    final data = jsonDecode(response.body);
    if (data['state'] != true || data['evaluates'] == null) return [];
    final result = data['evaluates'] as List<dynamic>;
    final json = result.map((e) => (e as Map<String, dynamic>)).toList();
    return json;
  }
}
