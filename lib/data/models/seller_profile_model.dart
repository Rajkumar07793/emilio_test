import 'package:hive/hive.dart';

part 'seller_profile_model.g.dart';

@HiveType(typeId: 1)
class SellerProfileModel extends HiveObject {
  @HiveField(0)
  final String sellerId;

  @HiveField(1)
  final String shopName;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String? profilePhotoPath;

  @HiveField(4)
  final bool isProfileComplete;

  SellerProfileModel({
    required this.sellerId,
    required this.shopName,
    required this.address,
    this.profilePhotoPath,
    this.isProfileComplete = true,
  });

  SellerProfileModel copyWith({
    String? sellerId,
    String? shopName,
    String? address,
    String? profilePhotoPath,
    bool? isProfileComplete,
  }) {
    return SellerProfileModel(
      sellerId: sellerId ?? this.sellerId,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
