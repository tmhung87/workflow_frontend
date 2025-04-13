import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workflow/models/task.dart';
import 'package:workflow/service/task_api.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> findtasks({int? id, String? title, String? description}) async {
    var response = await TaskApiService.findTask(
      title: title,
      description: description,
    );

    var map = jsonDecode(response.body);
    if (map['state'] == false) {
      return;
    }
    final tasksmap = map['tasks'] as List<dynamic>;
    _tasks =
        tasksmap.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  Future<Map<String, dynamic>> createtask(Task task) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      return {};
    }
    final map = await TaskApiService.createTask(task: task, token: token);
    return map;
  }

  Future<Map<String, dynamic>> deleteTask(int id) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      return {};
    }
    final map = await TaskApiService.deleteTask(id, token);
    return map;
  }

  Future<Map<String, dynamic>> updateTask(Task task) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      return {};
    }
    final map = await TaskApiService.updateTask(task, token);
    return map;
  }

  Task? _selectedtask;

  Task? get selectedtask => _selectedtask;

  void setSelectedtask(Task task) {
    _selectedtask = task;
    notifyListeners();
  }

  void clear() {
    _tasks = [];
    _selectedtask = null;
  }
}
