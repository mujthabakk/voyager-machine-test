import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common_widgets.dart' as common;
import '../../models/user_model.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppConstants.marginMedium),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                  _descriptionController.clear();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    ref
                        .read(categoryControllerProvider.notifier)
                        .addCategory(
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                        );
                    Navigator.pop(context);
                    _nameController.clear();
                    _descriptionController.clear();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final currentUser = ref.watch(currentUserProvider);

    ref.listen(categoryControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category operation completed successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Categories'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (currentUser?.role == UserRole.admin)
            IconButton(
              onPressed: _showAddCategoryDialog,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return common.EmptyWidget(
              message: 'No categories found',
              icon: Icons.category_outlined,
              action:
                  currentUser?.role == UserRole.admin
                      ? ElevatedButton(
                        onPressed: _showAddCategoryDialog,
                        child: const Text('Add Category'),
                      )
                      : null,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.only(
                  bottom: AppConstants.marginMedium,
                ),
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(
                    AppConstants.paddingMedium,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.category, color: AppColors.primary),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle:
                      category.description.isNotEmpty
                          ? Text(
                            category.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          )
                          : null,
                  onTap: () {
                    context.push('/products?category=${category.name}');
                  },
                  trailing:
                      currentUser?.role == UserRole.admin
                          ? PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: AppColors.error,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Delete Category'),
                                        content: Text(
                                          'Are you sure you want to delete "${category.name}"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                    categoryControllerProvider
                                                        .notifier,
                                                  )
                                                  .deleteCategory(category.id);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.error,
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                );
                              }
                            },
                          )
                          : const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        },
        loading:
            () => const common.LoadingWidget(message: 'Loading categories...'),
        error:
            (error, _) => common.ErrorWidget(
              message: error.toString(),
              onRetry: () => ref.invalidate(categoriesProvider),
            ),
      ),
    );
  }
}
