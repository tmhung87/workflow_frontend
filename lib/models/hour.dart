import 'package:workflow/utils/tomysqldate.dart';

class Hour {
  final int? id;
  final int workId;
  final String staffId;
  final double workHours;
  final String createdBy;
  final DateTime createdAt;

  Hour({
    this.id,
    required this.workId,
    required this.staffId,
    required this.workHours,
    required this.createdBy,
    required this.createdAt,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      id: json['id'],
      workId: json['workId'],
      staffId: json['staffId'] ?? '',
      workHours: (json['workHours'] ?? 0).toDouble(),
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workId': workId,
      'staffId': staffId,
      'workHours': workHours,
      'createdBy': createdBy,
      'createdAt': toMySQLDate(createdAt),
    };
  }
}
