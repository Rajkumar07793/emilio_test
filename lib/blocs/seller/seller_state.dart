import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class SellerState extends Equatable {
  const SellerState();

  @override
  List<Object?> get props => [];
}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerLoaded extends SellerState {
  final List<UserModel> sellers;

  const SellerLoaded({required this.sellers});

  @override
  List<Object?> get props => [sellers];
}

class SellerCreated extends SellerState {
  final UserModel seller;

  const SellerCreated({required this.seller});

  @override
  List<Object?> get props => [seller];
}

class SellerError extends SellerState {
  final String message;

  const SellerError({required this.message});

  @override
  List<Object?> get props => [message];
}
