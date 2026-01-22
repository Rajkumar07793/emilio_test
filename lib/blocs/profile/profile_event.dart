import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final String sellerId;

  const LoadProfileEvent({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}

class CreateProfileEvent extends ProfileEvent {
  final String sellerId;
  final String shopName;
  final String address;
  final String? profilePhotoPath;

  const CreateProfileEvent({
    required this.sellerId,
    required this.shopName,
    required this.address,
    this.profilePhotoPath,
  });

  @override
  List<Object?> get props => [sellerId, shopName, address, profilePhotoPath];
}
