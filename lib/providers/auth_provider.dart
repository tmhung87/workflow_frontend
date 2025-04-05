import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workflow/service/auth_api.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage(); // Khởi tạo sẵn
  String? _staffId;

  Future<Map<String, dynamic>> login(String staffId, String password) async {
    final response = await AuthApiService.login(staffId, password);
    if (response['success'] == true) {
      await _storage.write(key: 'token', value: response['token']);
      await _storage.write(key: 'staffId', value: staffId.toUpperCase());
      _staffId = staffId;
      notifyListeners();
    }
    return response;
  }

  void logout() async {
    await _storage.delete(key: 'token'); // Xóa token khi logout
    _staffId = null;
    notifyListeners();
  }
}
