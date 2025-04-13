import 'package:intl/intl.dart';
import 'package:workflow/models/task.dart';
import 'package:workflow/utils/tomysqldate.dart';

class Work {
  final int? workId;
  final Task? task;
  final String? status;
  final String? assigned;
  final int? percent;
  final double? actualHours;
  final String? remark;
  final String? createdBy;
  final DateTime? createdAt;
  final String? doneBy;
  final DateTime? doneAt;
  final List<Map<String, dynamic>> history;

  Work({
    this.workId,
    this.task,
    this.status,
    this.assigned,
    this.percent,
    this.actualHours,
    this.remark,
    this.createdBy,
    this.createdAt,
    this.doneBy,
    this.doneAt,
    required this.history,
  });

  Work copyWith({
    int? workId,
    Task? task,
    String? status,
    String? assigned,
    int? percent,
    double? actualHours,
    String? remark,
    String? createdBy,
    DateTime? createdAt,
    String? doneBy,
    DateTime? doneAt,
    List<Map<String, dynamic>>? history,
  }) {
    final work = Work(
      workId: workId ?? this.workId,
      task: task ?? this.task,
      status: status ?? this.status,
      assigned: assigned ?? this.assigned,
      percent: percent ?? this.percent,
      actualHours: actualHours ?? this.actualHours,
      remark: remark ?? this.remark,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      doneBy: doneBy ?? this.doneBy,
      doneAt: doneAt ?? this.doneAt,
      history: history ?? this.history,
    );
    return work;
  }

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      workId: json['workId'],
      task:
          (json['taskId'] != null ||
                  json['title'] != null ||
                  json['description'] != null ||
                  json['point'] != null ||
                  json['estimatedHours'] != null)
              ? Task(
                taskId: json['taskId'] ?? '',
                title: json['title'] ?? '',
                description: json['description'] ?? '',
                point: json['point'] ?? 0,
                estimatedHours: json['estimatedHours'] ?? 0,
              )
              : null,
      status: json['status'],
      assigned: json['assigned'],
      percent: json['percent'],
      actualHours:
          json['actualHours'] != null
              ? (json['actualHours'] as num).toDouble()
              : null,
      remark: json['remark'],
      createdBy: json['createdBy'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      doneBy: json['doneBy'],
      doneAt: json['doneAt'] != null ? DateTime.tryParse(json['doneAt']) : null,
      history:
          (json['history'] as List?)!
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workId': workId,
      'taskId': task?.taskId,
      'status': status,
      'assigned': assigned,
      'percent': percent,
      'actualHours': actualHours,
      'remark': remark,
      'createdBy': createdBy,
      'createdAt': toMySQLDate(createdAt),
      'doneBy': doneBy,
      'doneAt': toMySQLDate(doneAt),
      'history': history,
    };
  }
}
