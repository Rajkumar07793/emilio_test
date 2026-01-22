import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../../core/constants/hive_boxes.dart';

class AuthRepository {
  Future<UserModel?> login(String email, String password) async {
    final box = await Hive.openBox<UserModel>(HiveBoxes.users);

    // Find user by email
    final user = box.values.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );

    // Check if user is active
    if (!user.isActive) {
      throw Exception('Your account has been deactivated');
    }

    // Save current user
    final currentUserBox = await Hive.openBox(HiveBoxes.currentUser);
    await currentUserBox.put('userId', user.id);

    return user;
  }

  Future<UserModel> register(String email, String password) async {
    final box = await Hive.openBox<UserModel>(HiveBoxes.users);

    // Check if email already exists
    final existingUser = box.values.where((user) => user.email == email);
    if (existingUser.isNotEmpty) {
      throw Exception('Email already exists');
    }

    // Create new admin user
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      password: password,
      role: UserRole.admin,
      createdAt: DateTime.now(),
    );

    await box.put(user.id, user);
    return user;
  }

  Future<void> logout() async {
    final currentUserBox = await Hive.openBox(HiveBoxes.currentUser);
    await currentUserBox.clear();
  }

  Future<UserModel?> getCurrentUser() async {
    final currentUserBox = await Hive.openBox(HiveBoxes.currentUser);
    final userId = currentUserBox.get('userId');

    if (userId == null) return null;

    final box = await Hive.openBox<UserModel>(HiveBoxes.users);
    return box.get(userId);
  }
}
