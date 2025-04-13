import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:workflow/models/task.dart';

class TaskApiService {
  static final String _apiUrl =
      dotenv.env['URL'] ?? 'http://localhost:3000/api';

  static Future<Map<String, dynamic>> gettask() async {
    final response = await http.get(Uri.parse('$_apiUrl/task'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getTaskById(String id) async {
    final response = await http.get(Uri.parse('$_apiUrl/task/$id'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateTask(
    Task task,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/task/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteTask(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$_apiUrl/task/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createTask({
    required Task task,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/task/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task.toJson()),
    );
    var res = jsonDecode(response.body);
    print(res);
    return res;
  }

  static Future<Response> findTask({String? title, String? description}) async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$_apiUrl/task/find'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    return response;
  }
}
