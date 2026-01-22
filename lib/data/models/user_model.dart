import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final UserRole role;

  @HiveField(4)
  bool isActive;

  @HiveField(5)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    this.isActive = true,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 3)
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  seller,
}
