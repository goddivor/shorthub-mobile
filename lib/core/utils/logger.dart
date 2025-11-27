// lib/core/utils/logger.dart
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log GraphQL query
  static void graphqlQuery(String queryName, Map<String, dynamic>? variables) {
    _logger.i('📤 GraphQL Query: $queryName ${variables != null ? '\nVariables: $variables' : ''}');
  }

  /// Log GraphQL mutation
  static void graphqlMutation(String mutationName, Map<String, dynamic>? variables) {
    _logger.i('📤 GraphQL Mutation: $mutationName ${variables != null ? '\nVariables: $variables' : ''}');
  }

  /// Log GraphQL success
  static void graphqlSuccess(String operation, dynamic data) {
    _logger.d('✅ GraphQL Success: $operation\nData: $data');
  }

  /// Log GraphQL error
  static void graphqlError(String operation, dynamic error) {
    _logger.e('❌ GraphQL Error: $operation\nError: $error');
  }

  /// Log general info
  static void info(String message) {
    _logger.i('💡 $message');
  }

  /// Log warning
  static void warning(String message) {
    _logger.w('⚠️  $message');
  }

  /// Log error
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('❌ $message', error: error, stackTrace: stackTrace);
  }

  /// Log debug
  static void debug(String message) {
    _logger.d('🔍 $message');
  }

  /// Log success
  static void success(String message) {
    _logger.i('✅ $message');
  }
}
