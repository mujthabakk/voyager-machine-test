import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/email_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/product_card.dart';
import '../../widgets/common_widgets.dart' as common;

class ProductsScreen extends ConsumerStatefulWidget {
  final String? category;

  const ProductsScreen({super.key, this.category});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedCategory;
  final List<String> _selectedProductIds = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showEmailDialog() {
    if (_selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Send Product Details'),
            content: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _sendEmail();
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ],
          ),
    );
  }

  void _sendEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final productsAsync =
        _selectedCategory != null
            ? ref.read(productsByCategoryProvider(_selectedCategory!))
            : ref.read(productsProvider);

    productsAsync.whenData((products) {
      final selectedProducts =
          products
              .where((product) => _selectedProductIds.contains(product.id))
              .toList();

      if (selectedProducts.isNotEmpty) {
        ref
            .read(emailControllerProvider.notifier)
            .sendProductDetails(
              recipientEmail: email,
              products: selectedProducts,
            );
      }
    });

    _emailController.clear();
    setState(() {
      _selectedProductIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync =
        _selectedCategory != null
            ? ref.watch(productsByCategoryProvider(_selectedCategory!))
            : ref.watch(productsProvider);

    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _selectedCategory != null
              ? 'Products - $_selectedCategory'
              : 'All Products',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedProductIds.isNotEmpty)
            IconButton(
              onPressed: _showEmailDialog,
              icon: Badge(
                label: Text(_selectedProductIds.length.toString()),
                child: const Icon(Icons.email),
              ),
            ),
          IconButton(
            onPressed: () => context.push('/add-product'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: AppConstants.marginMedium),
                categoriesAsync.when(
                  data:
                      (categories) => SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: const Text('All'),
                                  selected: _selectedCategory == null,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = null;
                                      _selectedProductIds.clear();
                                    });
                                  },
                                ),
                              );
                            }
                            final category = categories[index - 1];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category.name),
                                selected: _selectedCategory == category.name,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory =
                                        selected ? category.name : null;
                                    _selectedProductIds.clear();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  loading: () => const SizedBox(height: 40),
                  error: (error, _) => const SizedBox(height: 40),
                ),
              ],
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filteredProducts =
                    _searchController.text.isEmpty
                        ? products
                        : products
                            .where(
                              (product) =>
                                  product.productName.toLowerCase().contains(
                                    _searchController.text.toLowerCase(),
                                  ) ||
                                  product.productCode.toLowerCase().contains(
                                    _searchController.text.toLowerCase(),
                                  ),
                            )
                            .toList();

                if (filteredProducts.isEmpty) {
                  return const common.EmptyWidget(
                    message: 'No products found',
                    icon: Icons.inventory_2_outlined,
                  );
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final isSelected = _selectedProductIds.contains(product.id);

                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.push('/product-details/${product.id}');
                      },
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedProductIds.add(product.id);
                            } else {
                              _selectedProductIds.remove(product.id);
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
              loading:
                  () => const common.LoadingWidget(
                    message: 'Loading products...',
                  ),
              error:
                  (error, _) => common.ErrorWidget(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(productsProvider),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
