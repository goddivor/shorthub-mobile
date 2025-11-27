// lib/screens/auth/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/logger.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait a bit for splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Use ref.watch to listen to state changes instead of ref.read
    // This will trigger a rebuild when the auth state changes
    final userState = ref.read(currentUserProvider);

    AppLogger.debug('User state type: ${userState.runtimeType}');

    userState.when(
      data: (user) {
        AppLogger.debug('User state is DATA, user is ${user == null ? "null" : "not null"}');
        if (user == null) {
          // Not authenticated, go to login
          AppLogger.debug('Navigating to login');
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else if (user.role != null) {
          // Authenticated, go to appropriate dashboard
          AppLogger.debug('Navigating to dashboard for role: ${user.role}');
          final route = AppRouter.getDashboardRoute(user.role!);
          Navigator.of(context).pushReplacementNamed(route);
        } else {
          // User doesn't have a role, go to login
          AppLogger.debug('User has no role, navigating to login');
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      },
      loading: () {
        AppLogger.debug('User state is LOADING - waiting...');
        // Still loading, wait a bit more and try again
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _checkAuth();
          }
        });
      },
      error: (error, _) {
        AppLogger.debug('User state is ERROR: $error');
        // Error, go to login
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Iconsax.video_play,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),

            // App Name
            const Text(
              'ShortHub',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Gestion Collaborative de Shorts',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
