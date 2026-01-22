import 'package:hive/hive.dart';
import '../models/seller_profile_model.dart';
import '../../core/constants/hive_boxes.dart';

class SellerProfileRepository {
  Future<SellerProfileModel> createProfile({
    required String sellerId,
    required String shopName,
    required String address,
    String? profilePhotoPath,
  }) async {
    final box = await Hive.openBox<SellerProfileModel>(
      HiveBoxes.sellerProfiles,
    );

    final profile = SellerProfileModel(
      sellerId: sellerId,
      shopName: shopName,
      address: address,
      profilePhotoPath: profilePhotoPath,
      isProfileComplete: true,
    );

    await box.put(sellerId, profile);
    return profile;
  }

  Future<SellerProfileModel?> getProfile(String sellerId) async {
    final box = await Hive.openBox<SellerProfileModel>(
      HiveBoxes.sellerProfiles,
    );
    return box.get(sellerId);
  }

  Future<SellerProfileModel> updateProfile({
    required String sellerId,
    required String shopName,
    required String address,
    String? profilePhotoPath,
  }) async {
    final box = await Hive.openBox<SellerProfileModel>(
      HiveBoxes.sellerProfiles,
    );

    final profile = SellerProfileModel(
      sellerId: sellerId,
      shopName: shopName,
      address: address,
      profilePhotoPath: profilePhotoPath,
      isProfileComplete: true,
    );

    await box.put(sellerId, profile);
    return profile;
  }
}
