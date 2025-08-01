import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Welcome, ${currentUser?.name ?? 'User'}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
              context.push('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppConstants.marginMedium),
            if (currentUser?.role == UserRole.admin) ...[
              _buildAdminDashboard(context),
            ] else ...[
              _buildCustomerDashboard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDashboard(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.marginMedium,
        mainAxisSpacing: AppConstants.marginMedium,
        children: [
          _buildDashboardCard(
            context: context,
            title: 'Manage Categories',
            icon: Icons.category,
            color: AppColors.primary,
            onTap: () => context.push('/categories'),
          ),
          _buildDashboardCard(
            context: context,
            title: 'Add Product',
            icon: Icons.add_box,
            color: AppColors.success,
            onTap: () => context.push('/add-product'),
          ),
          _buildDashboardCard(
            context: context,
            title: 'All Products',
            icon: Icons.inventory,
            color: AppColors.secondary,
            onTap: () => context.push('/products'),
          ),
          // _buildDashboardCard(
          //   context: context,
          //   title: 'Settings',
          //   icon: Icons.settings,
          //   color: AppColors.textSecondary,
          //   onTap: () => context.push('/settings'),
          // ),
        ],
      ),
    );
  }

  Widget _buildCustomerDashboard(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.marginMedium,
        mainAxisSpacing: AppConstants.marginMedium,
        children: [
          _buildDashboardCard(
            context: context,
            title: 'Browse Products',
            icon: Icons.shopping_bag,
            color: AppColors.primary,
            onTap: () => context.push('/products'),
          ),
          _buildDashboardCard(
            context: context,
            title: 'Categories',
            icon: Icons.category,
            color: AppColors.secondary,
            onTap: () => context.push('/categories'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppConstants.iconSizeLarge,
                  color: color,
                ),
              ),
              const SizedBox(height: AppConstants.marginMedium),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
