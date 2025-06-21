import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/service/auth_api.dart';
import 'package:workflow/views/auth/loginpage.dart';
import 'package:workflow/views/home/homepage.dart';

class AuthProvider with ChangeNotifier {
  User? _auth;
  User? get auth => _auth;

  Future<void> login(
    BuildContext context,
    String staffId,
    String password,
  ) async {
  final SharedPreferences storage = await SharedPreferences.getInstance(); // Khởi tạo sẵn

    final response = await AuthApiService.login(
      staffId.toUpperCase(),
      password,
    );
    final map = jsonDecode(response.body);

    if (map['state'] == true) {
      await storage.setString( 'token',  map['token']);
      await storage.setString( 'name',  staffId.toUpperCase());
      await storage.setString( 'password',  password);
      _auth = User.fromJson(map['user']);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    }
  }

  void logout(BuildContext context) async {
      final SharedPreferences storage = await SharedPreferences.getInstance(); // Khởi tạo sẵn
    await storage.remove( 'token'); // Xóa token khi logout
    await storage.remove( 'password');
    _auth = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
