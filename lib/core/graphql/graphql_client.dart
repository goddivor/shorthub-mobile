// lib/core/graphql/graphql_client.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../services/storage_service.dart';
import '../utils/logger.dart';
import 'mutations.dart';

class GraphQLClientService {
  static GraphQLClient? _client;
  static ValueNotifier<GraphQLClient>? _clientNotifier;
  static bool _isRefreshing = false;

  /// Callback triggered when refresh token fails (user must re-login)
  static VoidCallback? onAuthFailure;

  /// Get GraphQL endpoint from environment
  static String get graphqlEndpoint =>
      dotenv.env['GRAPHQL_ENDPOINT'] ?? 'http://localhost:4000/graphql';

  /// Get WebSocket endpoint from environment
  static String get wsEndpoint =>
      dotenv.env['WS_ENDPOINT'] ?? 'ws://localhost:4000/graphql';

  /// Initialize GraphQL client
  static Future<void> initialize() async {
    try {
      AppLogger.info('Initializing GraphQL client with endpoint: $graphqlEndpoint');

      // Initialize Hive for caching
      await initHiveForFlutter();

      // Create HttpLink
      final HttpLink httpLink = HttpLink(
        graphqlEndpoint,
        defaultHeaders: {
          'Content-Type': 'application/json',
        },
      );

      final AuthLink authLink = AuthLink(
        getToken: () async {
          final token = await StorageService.getAuthToken();
          return token != null ? 'Bearer $token' : '';
        },
      );

      // WebSocket link for subscriptions
      final WebSocketLink wsLink = WebSocketLink(
        wsEndpoint,
        config: SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: const Duration(seconds: 30),
          initialPayload: () async {
            final token = await StorageService.getAuthToken();
            return token != null ? {'Authorization': 'Bearer $token'} : {};
          },
        ),
      );

      // Split link: subscriptions via WebSocket, everything else via HTTP
      final Link link = Link.split(
        (request) => request.isSubscription,
        wsLink,
        authLink.concat(httpLink),
      );

      _client = GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: link,
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.cacheAndNetwork,
          ),
        ),
      );

      if (_clientNotifier == null) {
        _clientNotifier = ValueNotifier<GraphQLClient>(_client!);
      } else {
        _clientNotifier!.value = _client!;
      }

      AppLogger.success('GraphQL client initialized successfully');
    } catch (e) {
      AppLogger.warning('Failed to initialize with HiveStore, falling back to InMemoryStore: $e');

      final HttpLink httpLink = HttpLink(
        graphqlEndpoint,
        defaultHeaders: {
          'Content-Type': 'application/json',
        },
      );

      final AuthLink authLink = AuthLink(
        getToken: () async {
          final token = await StorageService.getAuthToken();
          return token != null ? 'Bearer $token' : '';
        },
      );

      final Link link = authLink.concat(httpLink);

      _client = GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: link,
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.cacheAndNetwork,
          ),
        ),
      );

      if (_clientNotifier == null) {
        _clientNotifier = ValueNotifier<GraphQLClient>(_client!);
      } else {
        _clientNotifier!.value = _client!;
      }

      AppLogger.success('GraphQL client initialized with InMemoryStore');
    }
  }

  /// Get client instance
  static GraphQLClient get client {
    if (_client == null) {
      throw Exception('GraphQLClient not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Get client notifier for GraphQLProvider
  static ValueNotifier<GraphQLClient> get clientNotifier {
    if (_clientNotifier == null) {
      throw Exception('GraphQLClient not initialized. Call initialize() first.');
    }
    return _clientNotifier!;
  }

  /// Update client with new auth token
  static Future<void> updateAuthToken(String? token) async {
    if (token != null) {
      AppLogger.info('Updating auth token in GraphQL client');
      await StorageService.setAuthToken(token);
    } else {
      AppLogger.info('Clearing auth token from GraphQL client');
      await StorageService.clearAuthTokens();
    }

    // Reinitialize client with new token
    await initialize();
  }

  /// Try to refresh the access token using the stored refresh token.
  /// Returns the new access token on success, null on failure.
  static Future<String?> _tryRefreshToken() async {
    if (_isRefreshing) return null;
    _isRefreshing = true;

    try {
      final currentRefreshToken = await StorageService.getRefreshToken();
      if (currentRefreshToken == null) return null;

      String deviceInfo = 'Flutter Mobile';
      try {
        final deviceInfoPlugin = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final info = await deviceInfoPlugin.androidInfo;
          deviceInfo = '${info.brand} ${info.model} (Android ${info.version.release})';
        } else if (Platform.isIOS) {
          final info = await deviceInfoPlugin.iosInfo;
          deviceInfo = '${info.name} (iOS ${info.systemVersion})';
        }
      } catch (_) {}

      AppLogger.info('Attempting token refresh...');

      final result = await client.mutate(
        MutationOptions(
          document: gql(refreshTokenMutation),
          variables: {
            'token': currentRefreshToken,
            'platform': 'MOBILE',
            'deviceInfo': deviceInfo,
          },
        ),
      );

      if (result.hasException || result.data?['refreshToken'] == null) {
        AppLogger.warning('Token refresh failed');
        return null;
      }

      final data = result.data!['refreshToken'];
      final newToken = data['token'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await StorageService.setAuthToken(newToken);
      await StorageService.setRefreshToken(newRefreshToken);
      await initialize();

      AppLogger.success('Token refreshed successfully');
      return newToken;
    } catch (e) {
      AppLogger.error('Token refresh error', e);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Check if an exception contains an UNAUTHENTICATED error
  static bool _isAuthError(OperationException exception) {
    for (final error in exception.graphqlErrors) {
      final code = error.extensions?['code'];
      if (code == 'UNAUTHENTICATED') return true;
    }
    return false;
  }

  /// Execute a query with automatic token refresh on auth failure
  static Future<QueryResult> queryWithRefresh(QueryOptions options) async {
    final result = await client.query(options);

    if (result.hasException && _isAuthError(result.exception!)) {
      final newToken = await _tryRefreshToken();
      if (newToken != null) {
        AppLogger.info('Retrying query after token refresh');
        return await client.query(options);
      }
      onAuthFailure?.call();
    }

    return result;
  }

  /// Execute a mutation with automatic token refresh on auth failure
  static Future<QueryResult> mutateWithRefresh(MutationOptions options) async {
    final result = await client.mutate(options);

    if (result.hasException && _isAuthError(result.exception!)) {
      final newToken = await _tryRefreshToken();
      if (newToken != null) {
        AppLogger.info('Retrying mutation after token refresh');
        return await client.mutate(options);
      }
      onAuthFailure?.call();
    }

    return result;
  }

  /// Clear cache
  static Future<void> clearCache() async {
    _client?.cache.store.reset();
  }

  /// Dispose client
  static Future<void> dispose() async {
    _clientNotifier?.dispose();
    _client = null;
    _clientNotifier = null;
  }
}
