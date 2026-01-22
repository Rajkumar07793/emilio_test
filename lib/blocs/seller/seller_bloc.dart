import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/user_repository.dart';
import 'seller_event.dart';
import 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final UserRepository userRepository;

  SellerBloc({required this.userRepository}) : super(SellerInitial()) {
    on<CreateSellerEvent>(_onCreateSeller);
    on<LoadSellersEvent>(_onLoadSellers);
    on<DeactivateSellerEvent>(_onDeactivateSeller);
  }

  Future<void> _onCreateSeller(
    CreateSellerEvent event,
    Emitter<SellerState> emit,
  ) async {
    emit(SellerLoading());
    try {
      final seller = await userRepository.createSeller(
        event.email,
        event.password,
      );
      emit(SellerCreated(seller: seller));
    } catch (e) {
      emit(SellerError(message: e.toString()));
    }
  }

  Future<void> _onLoadSellers(
    LoadSellersEvent event,
    Emitter<SellerState> emit,
  ) async {
    emit(SellerLoading());
    try {
      final sellers = await userRepository.getAllSellers();
      emit(SellerLoaded(sellers: sellers));
    } catch (e) {
      emit(SellerError(message: e.toString()));
    }
  }

  Future<void> _onDeactivateSeller(
    DeactivateSellerEvent event,
    Emitter<SellerState> emit,
  ) async {
    try {
      await userRepository.deactivateSeller(event.sellerId);
      // Reload sellers after deactivation
      final sellers = await userRepository.getAllSellers();
      emit(SellerLoaded(sellers: sellers));
    } catch (e) {
      emit(SellerError(message: e.toString()));
    }
  }
}
