import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  void startLoading() {
    _loading = true;
    notifyListeners();
  }

  void endLoading() {
    _loading = false;
    notifyListeners();
  }

  Map<String, dynamic> _map = {};
  Map<String, dynamic> get map => _map;
  void update(Map<String, dynamic> map) {
    _map.clear();
    _map.addAll(map);
  }
}
