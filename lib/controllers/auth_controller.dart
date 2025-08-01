import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final currentUserProvider = StateProvider<AppUser?>((ref) => null);

final authStateProvider = StreamProvider<UserRole?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.authStateChanges.asyncMap((user) async {
    if (user != null) {
      final appUser = await authService.getUserData(user.uid);
      ref.read(currentUserProvider.notifier).state = appUser;
      return appUser?.role;
    } else {
      ref.read(currentUserProvider.notifier).state = null;
      return null;
    }
  });
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  final Ref _ref;

  AuthController(this._authService, this._ref) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      if (user != null) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Sign up failed', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );
      if (user != null) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Sign in failed', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      _ref.read(currentUserProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthController(authService, ref);
});
