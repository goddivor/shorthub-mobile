// lib/config/constants.dart

// ignore_for_file: constant_identifier_names

/// Configuration constants for ShortHub app
class AppConstants {
  AppConstants._();

  // API Configuration
  static const String graphqlEndpoint =
      String.fromEnvironment('GRAPHQL_ENDPOINT', defaultValue: 'http://localhost:4000/graphql');
  static const String wsEndpoint =
      String.fromEnvironment('WS_ENDPOINT', defaultValue: 'ws://localhost:4000/graphql');

  // App Info
  static const String appName = 'ShortHub';
  static const String appVersion = '2.0.0';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheExpiration = Duration(hours: 1);
}

/// Short Status
enum ShortStatus {
  ROLLED,
  RETAINED,
  REJECTED,
  ASSIGNED,
  IN_PROGRESS,
  COMPLETED,
  VALIDATED,
  PUBLISHED,
}

/// User Roles
enum UserRole {
  ADMIN,
  VIDEASTE,
  ASSISTANT,
}

/// User Status
enum UserStatus {
  ACTIVE,
  BLOCKED,
}

/// Content Type
enum ContentType {
  VA_SANS_EDIT,
  VA_AVEC_EDIT,
  VF_SANS_EDIT,
  VF_AVEC_EDIT,
  VO_SANS_EDIT,
  VO_AVEC_EDIT,
}

/// Notification Type
enum NotificationType {
  VIDEO_ASSIGNED,
  DEADLINE_REMINDER,
  VIDEO_COMPLETED,
  VIDEO_VALIDATED,
  VIDEO_REJECTED,
  ACCOUNT_BLOCKED,
  ACCOUNT_UNBLOCKED,
}
