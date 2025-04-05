// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final int id;
  final String? staffId;
  final String? name;
  final String? email;
  final String? password;
  final String? division;
  final String? department;
  final String? position;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final int? point;
  User({
    required this.id,
    this.staffId,
    this.name,
    this.email,
    this.password,
    this.division,
    this.department,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.point,
  });

  User copyWith({
    int? id,
    String? staffId,
    String? name,
    String? email,
    String? password,
    String? division,
    String? department,
    String? position,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      division: division ?? this.division,
      department: department ?? this.department,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      point: point ?? this.point,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'staff_id': staffId,
      'name': name,
      'email': email,
      'password': password,
      'division': division,
      'department': department,
      'position': position,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'point': point,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      staffId: map['staff_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      division: map['division'] as String,
      department: map['department'] as String,
      position: map['position'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      point: map['point'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(Map<String, dynamic> source) => User.fromMap(source);

  @override
  String toString() {
    return 'User(id: $id, staffId: $staffId, name: $name, email: $email, password: $password, division: $division, department: $department, position: $position, createdAt: $createdAt, updatedAt: $updatedAt, point: $point)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.staffId == staffId &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.division == division &&
        other.department == department &&
        other.position == position &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.point == point;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        staffId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        division.hashCode ^
        department.hashCode ^
        position.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        point.hashCode;
  }
}
