import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/service/auth_api.dart';
import 'package:workflow/views/auth/loginpage.dart';
import 'package:workflow/views/home/homepage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Khởi tạo sẵn
  User? _auth;
  User? get auth => _auth;

  Future<void> login(
    BuildContext context,
    String staffId,
    String password,
  ) async {
    final response = await AuthApiService.login(
      staffId.toUpperCase(),
      password,
    );
    final map = jsonDecode(response.body);

    if (map['state'] == true) {
      await _storage.write(key: 'token', value: map['token']);
      await _storage.write(key: 'name', value: staffId.toUpperCase());
      await _storage.write(key: 'password', value: password);
      _auth = User.fromJson(map['user']);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    }
  }

  void logout(BuildContext context) async {
    await _storage.delete(key: 'token'); // Xóa token khi logout
    await _storage.delete(key: 'password');
    _auth = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
