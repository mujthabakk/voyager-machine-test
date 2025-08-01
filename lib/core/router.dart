import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../views/splash_screen.dart';
import '../views/login_screen.dart';
import '../views/register_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/products_screen.dart';
import '../views/add_product_screen.dart';
import '../views/categories_screen.dart';
import '../views/product_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.whenOrNull(
        data: (userRole) => userRole != null,
      ) ?? false;

      final isAuthPage = ['/login', '/register'].contains(state.fullPath);
      final isSplashPage = state.fullPath == '/';

      if (isSplashPage) {
        return null;
      }

      if (!isAuthenticated && !isAuthPage) {
        return '/login';
      }

      if (isAuthenticated && isAuthPage) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return ProductsScreen(category: category);
        },
      ),
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/product-details/:productId',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ProductDetailsScreen(productId: productId);
        },
      ),
    ],
  );
});
