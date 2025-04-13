class Task {
  final int? taskId;
  final String title;
  final String description;
  final int point;
  final double estimatedHours;
  final String type; // 'routine' | 'irregular'
  final String status; // 'active' | 'inactive'

  Task({
    this.taskId,
    required this.title,
    required this.description,
    this.point = 0,
    this.estimatedHours = 0.0,
    this.type = 'irregular',
    this.status = 'active',
  });

  Task copyWith({
    int? taskId,
    String? title,
    String? description,
    int? point,
    double? estimatedHours,
    String? type,
    String? status,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      point: point ?? this.point,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      point: json['point'] ?? 0,
      estimatedHours:
          (json['estimatedHours'] != null)
              ? (json['estimatedHours'] as num).toDouble()
              : 0.0,
      type: json['type'] ?? 'irregular',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taskId != null) 'taskId': taskId,
      'title': title,
      'description': description,
      'point': point,
      'estimatedHours': estimatedHours,
      'type': type,
      'status': status,
    };
  }
}
