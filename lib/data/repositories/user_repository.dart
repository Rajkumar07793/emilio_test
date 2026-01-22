import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../../core/constants/hive_boxes.dart';

class UserRepository {
  Future<UserModel> createSeller(String email, String password) async {
    final box = await Hive.openBox<UserModel>(HiveBoxes.users);

    // Check if email already exists
    final existingUser = box.values.where((user) => user.email == email);
    if (existingUser.isNotEmpty) {
      throw Exception('Email already exists');
    }

    // Create new seller user
    final seller = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      password: password,
      role: UserRole.seller,
      createdAt: DateTime.now(),
    );

    await box.put(seller.id, seller);
    return seller;
  }

  Future<List<UserModel>> getAllSellers() async {
    final box = await Hive.openBox<UserModel>(HiveBoxes.users);
    return box.values.where((user) => user.role == UserRole.seller).toList();
  }

  Future<void> deactivateSeller(String sellerId) async {
    final box = await Hive.openBox<UserModel>(HiveBoxes.users);
    final seller = box.get(sellerId);

    if (seller != null) {
      seller.isActive = false;
      await seller.save();
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    final box = await Hive.openBox<UserModel>(HiveBoxes.users);
    return box.get(userId);
  }
}
