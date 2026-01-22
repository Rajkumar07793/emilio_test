import 'package:hive/hive.dart';

import '../../core/constants/hive_boxes.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class ProductRepository {
  Future<ProductModel> createProduct({
    required String sellerId,
    required String title,
    required double price,
    required int stock,
  }) async {
    final box = await Hive.openBox<ProductModel>(HiveBoxes.products);

    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sellerId: sellerId,
      title: title,
      price: price,
      stock: stock,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await box.put(product.id, product);
    return product;
  }

  Future<List<ProductModel>> getProductsBySeller(String sellerId) async {
    final box = await Hive.openBox<ProductModel>(HiveBoxes.products);
    return box.values.where((product) => product.sellerId == sellerId).toList();
  }

  Future<List<ProductModel>> getActiveProducts() async {
    final box = await Hive.openBox<ProductModel>(HiveBoxes.products);
    final userBox = await Hive.openBox<UserModel>(HiveBoxes.users);

    // Get all products from active sellers
    return box.values.where((product) {
      final seller = userBox.get(product.sellerId);
      return seller != null && seller.isActive;
    }).toList();
  }

  Future<ProductModel> updateProduct({
    required String productId,
    required String title,
    required double price,
    required int stock,
  }) async {
    final box = await Hive.openBox<ProductModel>(HiveBoxes.products);
    final existingProduct = box.get(productId);

    if (existingProduct == null) {
      throw Exception('Product not found');
    }

    final updatedProduct = existingProduct.copyWith(
      title: title,
      price: price,
      stock: stock,
      updatedAt: DateTime.now(),
    );

    await box.put(productId, updatedProduct);
    return updatedProduct;
  }

  Future<void> deleteProduct(String productId) async {
    final box = await Hive.openBox<ProductModel>(HiveBoxes.products);
    await box.delete(productId);
  }

  Future<ProductModel?> getProductById(String productId) async {
    final box = await Hive.openBox<ProductModel>(HiveBoxes.products);
    return box.get(productId);
  }
}
