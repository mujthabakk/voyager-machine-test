import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';

final productServiceProvider = Provider<ProductService>((ref) => ProductService());
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

final productsProvider = StreamProvider<List<Product>>((ref) {
  final productService = ref.read(productServiceProvider);
  return productService.getProducts();
});

final productsByCategoryProvider = StreamProvider.family<List<Product>, String>((ref, category) {
  final productService = ref.read(productServiceProvider);
  return productService.getProductsByCategory(category);
});

class ProductController extends StateNotifier<AsyncValue<void>> {
  final ProductService _productService;
  final StorageService _storageService;

  ProductController(this._productService, this._storageService) 
      : super(const AsyncValue.data(null));

  Future<void> addProduct({
    required String productCode,
    required String productName,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required String createdBy,
    File? imageFile,
  }) async {
    state = const AsyncValue.loading();
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _storageService.uploadProductImage(imageFile);
      }

      final product = Product(
        id: '',
        productCode: productCode,
        productName: productName,
        description: description,
        price: price,
        quantity: quantity,
        imageUrl: imageUrl,
        category: category,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      await _productService.addProduct(product);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProduct(Product product, {File? newImageFile}) async {
    state = const AsyncValue.loading();
    try {
      String? imageUrl = product.imageUrl;
      
      if (newImageFile != null) {
        if (product.imageUrl != null) {
          await _storageService.deleteImage(product.imageUrl!);
        }
        imageUrl = await _storageService.uploadProductImage(newImageFile);
      }

      final updatedProduct = product.copyWith(imageUrl: imageUrl);
      await _productService.updateProduct(updatedProduct);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteProduct(Product product) async {
    state = const AsyncValue.loading();
    try {
      if (product.imageUrl != null) {
        await _storageService.deleteImage(product.imageUrl!);
      }
      await _productService.deleteProduct(product.id);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      return await _productService.searchProducts(query);
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
}

final productControllerProvider = StateNotifierProvider<ProductController, AsyncValue<void>>((ref) {
  final productService = ref.read(productServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return ProductController(productService, storageService);
});
