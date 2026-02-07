// lib/config/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/videaste/videaste_dashboard_screen.dart';
import '../../screens/assistant/assistant_dashboard_screen.dart';
import '../../screens/shared/short_details_screen.dart';
import '../../screens/shared/notifications_screen.dart';
import '../../screens/shared/profile_screen.dart';
import '../../screens/shared/settings_screen.dart';

/// App route names
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String videasteDashboard = '/videaste/dashboard';
  static const String assistantDashboard = '/assistant/dashboard';
  static const String shortDetails = '/short/details';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Generate routes for the app
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case AppRoutes.videasteDashboard:
        return MaterialPageRoute(builder: (_) => const VideasteDashboardScreen());

      case AppRoutes.assistantDashboard:
        return MaterialPageRoute(builder: (_) => const AssistantDashboardScreen());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.shortDetails:
        final shortId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ShortDetailsScreen(shortId: shortId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Get dashboard route based on user role
  static String getDashboardRoute(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return AppRoutes.adminDashboard;
      case 'VIDEASTE':
        return AppRoutes.videasteDashboard;
      case 'ASSISTANT':
        return AppRoutes.assistantDashboard;
      default:
        return AppRoutes.login;
    }
  }
}
