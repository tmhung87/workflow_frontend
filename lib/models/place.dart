class Place {
  final int? id;
  final String division;
  final String department;
  final String? position;
  final String createdBy;
  final DateTime? createdAt;

  Place({
    this.id,
    required this.division,
    required this.department,
    this.position,
    required this.createdBy,
    this.createdAt,
  });

  // 🛠️ Factory constructor từ JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      division: json['division'],
      department: json['department'],
      position: json['position'],
      createdBy: json['createdBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  // 📦 Convert về JSON (gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'division': division,
      'department': department,
      if (position != null) 'position': position,
      'createdBy': createdBy,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
