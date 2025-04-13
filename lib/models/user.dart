class User {
  final int? id;
  final String staffId;
  final String password;
  final String name;
  final String email;
  final String division;
  final String department;
  final String? position; // nullable now
  final int point;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.staffId,
    required this.password,
    required this.name,
    required this.email,
    required this.division,
    required this.department,
    this.position,
    this.point = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      staffId: json['staffId'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      division: json['division'] ?? '',
      department: json['department'] ?? '',
      position: json['position'], // nullable
      point: json['point'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'staffId': staffId,
      'password': password,
      'name': name,
      'email': email,
      'division': division,
      'department': department,
      if (position != null) 'position': position,
      'point': point,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
