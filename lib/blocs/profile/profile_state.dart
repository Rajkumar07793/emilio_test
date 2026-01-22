import 'package:equatable/equatable.dart';
import '../../data/models/seller_profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final SellerProfileModel? profile;

  const ProfileLoaded({this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileCreated extends ProfileState {
  final SellerProfileModel profile;

  const ProfileCreated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
