import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/models/hour.dart';

class HourApiService {
  static final String _baseUrl =
      'http://146.196.64.84/api/api';

  static Future<String?> _getToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString( 'token');
  }

  static Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Get all work hours
  static Future<List<Hour>> getAll() async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$_baseUrl/hour'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);
    if (data['state'] != true || data['hours'] == null) return [];

    return (data['hours'] as List).map((e) => Hour.fromJson(e)).toList();
  }

  // Create new work hour
  static Future<Map<String, dynamic>> create(Hour hour) async {
    final token = await _getToken();
    if (token == null) return {'state': false, 'message': 'Token not found'};

    final response = await http.post(
      Uri.parse('$_baseUrl/hour/create'),
      headers: _headers(token),
      body: jsonEncode(hour.toJson()),
    );

    return jsonDecode(response.body);
  }

  // Update work hour
  static Future<Map<String, dynamic>> update(Hour hour) async {
    final token = await _getToken();
    if (token == null) return {'state': false, 'message': 'Token not found'};

    final response = await http.put(
      Uri.parse('$_baseUrl/hour/update'),
      headers: _headers(token),
      body: jsonEncode(hour.toJson()),
    );

    return jsonDecode(response.body);
  }

  // Delete work hour by ID
  static Future<Map<String, dynamic>> delete(int id) async {
    final token = await _getToken();
    if (token == null) return {'state': false, 'message': 'Token not found'};

    final response = await http.delete(
      Uri.parse('$_baseUrl/hour/$id'),
      headers: _headers(token),
    );

    return jsonDecode(response.body);
  }

  // Get work hour by workId
  static Future<Map<String, dynamic>> getByWorkId(int workId) async {
    final token = await _getToken();
    if (token == null) return {};

    final response = await http.post(
      Uri.parse('$_baseUrl/hour/find'),
      headers: _headers(token),
      body: jsonEncode({'workId': workId}),
    );

    return jsonDecode(response.body);
  }
}
