import 'package:workflow/models/task.dart';
import 'package:workflow/utils/tomysqldate.dart';

class Work {
  final int? workId;
  final Task task; // Không cần nullable nữa, mặc định luôn có task
  final String status;
  final String assigned;
  final double percent;
  final double actualHours;
  final String remark;
  final String createdBy;
  final DateTime createdAt;
  final String? doneBy;
  final DateTime? doneAt;

  Work({
    this.workId,
    Task? task,
    String? status,
    String? assigned,
    double? percent,
    double? actualHours,
    String? remark,
    required this.createdBy,
    DateTime? createdAt,
    this.doneBy,
    this.doneAt,
  }) : task = task ?? Task(title: '', description: ''),
       status = status ?? 'issued',
       assigned = assigned ?? '',
       percent = percent ?? 0.0,
       actualHours = actualHours ?? 0.0,
       remark = remark ?? '',
       createdAt =
           createdAt ??
           DateTime.now(); // Nếu không truyền vào, dùng thời gian hiện tại

  factory Work.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và khởi tạo Task từ JSON
    final task =
        (json.containsKey('taskId') ||
                json.containsKey('title') ||
                json.containsKey('description') ||
                json.containsKey('point') ||
                json.containsKey('estimatedHours'))
            ? Task(
              taskId: json['taskId'] ?? '',
              title: json['title'] ?? '',
              description: json['description'] ?? '',
              point: json['point'] ?? 0,
              estimatedHours: (json['estimatedHours'] ?? 0).toDouble(),
            )
            : Task(
              title: '',
              description: '',
            ); // Nếu không có dữ liệu task, tạo task rỗng

    return Work(
      workId: json['workId'],
      task: task,
      status: json['status'] ?? 'issued',
      assigned: json['assigned'] ?? '',
      percent: (json['percent'] ?? 0).toDouble(),
      actualHours: (json['actualHours'] ?? 0).toDouble(),
      remark: json['remark'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : DateTime.now(), // Dùng thời gian hiện tại nếu không có giá trị createdAt
      doneBy: json['doneBy'],
      doneAt:
          json['doneAt'] != null
              ? DateTime.tryParse(json['doneAt'])
              : null, // Nếu không có doneAt, giữ null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workId': workId,
      'taskId': task.taskId, // task là không null, nên không cần kiểm tra null
      'status': status,
      'assigned': assigned,
      'percent': percent,
      'actualHours': actualHours,
      'remark': remark,
      'createdBy': createdBy,
      'createdAt': toMySQLDate(
        createdAt,
      ), // Sử dụng phương thức tiện ích để chuyển đổi thời gian
      'doneBy': doneBy,
      'doneAt': toMySQLDate(doneAt),
    };
  }

  Work copyWith({
    int? workId,
    Task? task,
    String? status,
    String? assigned,
    double? percent,
    double? actualHours,
    String? remark,
    String? createdBy,
    DateTime? createdAt,
    String? doneBy,
    DateTime? doneAt,
  }) {
    return Work(
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
    );
  }
}
