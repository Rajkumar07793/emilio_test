import 'package:equatable/equatable.dart';

abstract class SellerEvent extends Equatable {
  const SellerEvent();

  @override
  List<Object?> get props => [];
}

class CreateSellerEvent extends SellerEvent {
  final String email;
  final String password;

  const CreateSellerEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoadSellersEvent extends SellerEvent {}

class DeactivateSellerEvent extends SellerEvent {
  final String sellerId;

  const DeactivateSellerEvent({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}
