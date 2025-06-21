import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class AuthApiService {
  static final String _apiUrl =
      'http://146.196.64.84/api/api';

  // Hàm login
  static Future<Response> login(String staffId, String password) async {
    print('$_apiUrl/auth/login');
    final response = await http.post(
      Uri.parse('$_apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'staffId': staffId, 'password': password}),
    );

    return response;
  }

  // Lấy token từ FlutterSecureStorage
}
