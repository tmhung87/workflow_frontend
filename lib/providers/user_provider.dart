import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/models/user.dart';
import 'package:workflow/service/user_api.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> findUsers({
    String? staffId,
    String? name,
    String? division,
    String? department,
  }) async {
    var response = await UserApiService.findUser(
      staffId: staffId,
      name: name,
      division: division,
      department: department,
    );

    var map = jsonDecode(response.body);
    if (map['state'] == false) {
      return;
    }
    final usersmap = map['users'] as List<dynamic>;
    _users =
        usersmap.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  Future<Map<String, dynamic>> createUser(User user) async {
    final storage = await SharedPreferences.getInstance();
    final token = storage.getString( 'token');
    if (token == null) {
      return {};
    }
    final map = await UserApiService.createUser(user: user, token: token);
    return map;
  }

  User? _selectedUser;

  User? get selectedUser => _selectedUser;

  void setSelectedUser(User user) {
    _selectedUser = user;
    notifyListeners();
  }

  void clear() {
    _users = [];
    _selectedUser = null;
  }
}
