import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:workflow/models/user.dart';

class UserApiService {
  static final String _apiUrl =
      dotenv.env['URL'] ?? 'http://localhost:3000/api';

  static Future<Map<String, dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$_apiUrl/users'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await http.get(Uri.parse('$_apiUrl/users/$id'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateUser(
    String id,
    Map<String, dynamic> user,
  ) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/users/$id'),
      body: jsonEncode(user),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$_apiUrl/users/$id'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByStaffId(String staffId) async {
    final response = await http.get(Uri.parse('$_apiUrl/users/staff/$staffId'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$_apiUrl/users/email/$email'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByPhone(String phone) async {
    final response = await http.get(Uri.parse('$_apiUrl/users/phone/$phone'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByRole(String role) async {
    final response = await http.get(Uri.parse('$_apiUrl/users/role/$role'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByStatus(String status) async {
    final response = await http.get(Uri.parse('$_apiUrl/users/status/$status'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByDivision(String division) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/users/division/$division'),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByDepartment(
    String department,
  ) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/users/department/$department'),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getUserByPosition(String position) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/users/position/$position'),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createUser({
    required User user,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );
      var res = jsonDecode(response.body);

      return res;
    } catch (e) {
      return {'message': e};
    }
  }

  static Future<Response> findUser({
    String? staffId,
    String? name,
    String? division,
    String? department,
  }) async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$_apiUrl/user/findUsers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'staffId': staffId,
        'name': name,
        'division': division,
        'department': department,
      }),
    );

    return response;
  }
}
