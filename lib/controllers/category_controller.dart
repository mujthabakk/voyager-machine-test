import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) => CategoryService());

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final categoryService = ref.read(categoryServiceProvider);
  return categoryService.getCategories();
});

class CategoryController extends StateNotifier<AsyncValue<void>> {
  final CategoryService _categoryService;

  CategoryController(this._categoryService) : super(const AsyncValue.data(null));

  Future<void> addCategory({
    required String name,
    required String description,
  }) async {
    state = const AsyncValue.loading();
    try {
      final category = Category(
        id: '',
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );

      await _categoryService.addCategory(category);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateCategory(Category category) async {
    state = const AsyncValue.loading();
    try {
      await _categoryService.updateCategory(category);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    state = const AsyncValue.loading();
    try {
      await _categoryService.deleteCategory(categoryId);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final categoryControllerProvider = StateNotifierProvider<CategoryController, AsyncValue<void>>((ref) {
  final categoryService = ref.read(categoryServiceProvider);
  return CategoryController(categoryService);
});
