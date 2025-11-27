// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/user.dart';
import '../core/services/auth_service.dart';
import '../core/services/storage_service.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Current user provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<User?>>((ref) {
  return CurrentUserNotifier(ref);
});

/// Current user state notifier
class CurrentUserNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  /// Load user from storage/server
  Future<void> _loadUser() async {
    state = const AsyncValue.loading();

    try {
      // Check if authenticated
      final isAuth = await StorageService.isAuthenticated();
      if (!isAuth) {
        state = const AsyncValue.data(null);
        return;
      }

      // Get current user from storage first
      final cachedUser = await StorageService.getUser();
      if (cachedUser != null) {
        state = AsyncValue.data(cachedUser);
        return;
      }

      // If no cached user, try to fetch from server
      try {
        final authService = ref.read(authServiceProvider);
        final user = await authService.getCurrentUser();
        state = AsyncValue.data(user);
      } catch (e) {
        // If server fetch fails but we have a token,
        // treat as not authenticated and let user login again
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      // On any error, treat as not authenticated
      state = const AsyncValue.data(null);
    }
  }

  /// Login
  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final authPayload = await authService.login(username, password);
      state = AsyncValue.data(authPayload.user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh user data
  Future<void> refresh() async {
    await _loadUser();
  }

  /// Update user data
  void updateUser(User user) {
    state = AsyncValue.data(user);
    StorageService.setUser(user);
  }
}

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userState = ref.watch(currentUserProvider);
  return userState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Get user role
final userRoleProvider = Provider<String?>((ref) {
  final userState = ref.watch(currentUserProvider);
  return userState.when(
    data: (user) => user?.role,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Check if user is admin
final isAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == 'ADMIN';
});

/// Check if user is videaste
final isVideoasteProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == 'VIDEASTE';
});

/// Check if user is assistant
final isAssistantProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == 'ASSISTANT';
});
