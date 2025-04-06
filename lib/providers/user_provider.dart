import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    _users = await UserApiService.findUser(
      staffId: staffId,
      name: name,
      division: division,
      department: department,
    );
    notifyListeners();
  }

  Future<Map<String, dynamic>> createUser(User user) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
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
}
