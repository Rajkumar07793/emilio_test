import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/seller_profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SellerProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<CreateProfileEvent>(_onCreateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.getProfile(event.sellerId);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onCreateProfile(
    CreateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.createProfile(
        sellerId: event.sellerId,
        shopName: event.shopName,
        address: event.address,
        profilePhotoPath: event.profilePhotoPath,
      );
      emit(ProfileCreated(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
