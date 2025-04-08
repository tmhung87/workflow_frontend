import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:http/http.dart';

class AuthApiService {
  static final String _apiUrl =
      dotenv.env['URL'] ?? 'http://localhost:3000/api';

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
