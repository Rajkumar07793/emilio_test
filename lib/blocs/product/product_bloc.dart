import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadActiveProductsEvent>(_onLoadActiveProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getProductsBySeller(
        event.sellerId,
      );
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadActiveProducts(
    LoadActiveProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getActiveProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await productRepository.createProduct(
        sellerId: event.sellerId,
        title: event.title,
        price: event.price,
        stock: event.stock,
      );
      emit(
        const ProductOperationSuccess(message: 'Product created successfully'),
      );
      // Reload products
      final products = await productRepository.getProductsBySeller(
        event.sellerId,
      );
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final updatedProduct = await productRepository.updateProduct(
        productId: event.productId,
        title: event.title,
        price: event.price,
        stock: event.stock,
      );
      emit(
        const ProductOperationSuccess(message: 'Product updated successfully'),
      );
      // Reload products for the seller
      final products = await productRepository.getProductsBySeller(
        updatedProduct.sellerId,
      );
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final product = await productRepository.getProductById(event.productId);
      await productRepository.deleteProduct(event.productId);
      emit(
        const ProductOperationSuccess(message: 'Product deleted successfully'),
      );
      // Reload products
      if (product != null) {
        final products = await productRepository.getProductsBySeller(
          product.sellerId,
        );
        emit(ProductLoaded(products: products));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
