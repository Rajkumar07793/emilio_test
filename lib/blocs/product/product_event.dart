import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final String sellerId;

  const LoadProductsEvent({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}

class LoadActiveProductsEvent extends ProductEvent {}

class CreateProductEvent extends ProductEvent {
  final String sellerId;
  final String title;
  final double price;
  final int stock;

  const CreateProductEvent({
    required this.sellerId,
    required this.title,
    required this.price,
    required this.stock,
  });

  @override
  List<Object?> get props => [sellerId, title, price, stock];
}

class UpdateProductEvent extends ProductEvent {
  final String productId;
  final String title;
  final double price;
  final int stock;

  const UpdateProductEvent({
    required this.productId,
    required this.title,
    required this.price,
    required this.stock,
  });

  @override
  List<Object?> get props => [productId, title, price, stock];
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}
