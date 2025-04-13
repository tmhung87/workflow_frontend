import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workflow/models/work.dart';
import 'package:workflow/service/work_api.dart';

class WorkProvider extends ChangeNotifier {
  List<Work> _works = [];

  List<Work> get works => _works;

  // Future<void> findWorks({
  //   String? workId,
  //   String? title,
  //   String? description,
  //   String? assigned,
  //   String? status,
  //   DateTime? startTime,
  //   DateTime? endTime,
  // }) async {
  //   var response = await WorkApiService.findWork(
  //     workId: workId,
  //     title: title,
  //     description: description,
  //     assigned: assigned,
  //     status: status,
  //     startTime: startTime,
  //     endTime: endTime,
  //   );

  //   var map = jsonDecode(response.body);
  //   if (map['state'] == false) {
  //     return;
  //   }
  //   final worksmap = map['works'] as List<dynamic>;
  //   _works =
  //       worksmap.map((e) => Work.fromJson(e as Map<String, dynamic>)).toList();
  //   notifyListeners();
  // }

  // Future<Map<String, dynamic>> createWork(Work work) async {
  //   final storage = FlutterSecureStorage();
  //   final token = await storage.read(key: 'token');
  //   if (token == null) {
  //     return {};
  //   }
  //   final map = await WorkApiService.createWork(work: work, token: token);
  //   return map;
  // }

  // Future<Map<String, dynamic>> deleteWork(int id) async {
  //   final storage = FlutterSecureStorage();
  //   final token = await storage.read(key: 'token');
  //   if (token == null) {
  //     return {};
  //   }
  //   final map = await WorkApiService.deleteWork(id, token);
  //   return map;
  // }

  // Future<Map<String, dynamic>> updateWork(Work Work) async {
  //   final storage = FlutterSecureStorage();
  //   final token = await storage.read(key: 'token');
  //   if (token == null) {
  //     return {};
  //   }
  //   final map = await WorkApiService.updateWork(Work, token);
  //   return map;
  // }

  Work? _selectedWork;

  Work? get selectedWork => _selectedWork;

  void setSelectedWork(Work Work) {
    _selectedWork = Work;
    notifyListeners();
  }

  void clear() {
    _works = [];
    _selectedWork = null;
  }
}
