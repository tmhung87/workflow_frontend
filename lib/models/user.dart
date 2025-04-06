// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final int? id;
  final String staffId;
  final String name;
  final String? email;
  final String? password;
  final String division;
  final String department;
  final String? createdAt;
  final String? updatedAt;
  User({
    this.id,
    required this.staffId,
    required this.name,
    this.email,
    this.password,
    required this.division,
    required this.department,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    int? id,
    String? staffId,
    String? name,
    String? email,
    String? password,
    String? division,
    String? department,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'staffId': staffId,
      'name': name,
      'email': email,
      'password': password,
      'division': division,
      'department': department,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      staffId: map['staffId'] as String,
      name: map['name'] as String,
      email: map['email'] != null ? map['email'] as String : '',
      password: map['password'] != null ? map['password'] as String : '',
      division: map['division'] as String,
      department: map['department'] as String,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : '',
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, staffId: $staffId, name: $name, email: $email, password: $password, division: $division, department: $department, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
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
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
