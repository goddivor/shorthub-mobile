// lib/core/graphql/graphql_client.dart
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/storage_service.dart';
import '../utils/logger.dart';

class GraphQLClientService {
  static GraphQLClient? _client;
  static ValueNotifier<GraphQLClient>? _clientNotifier;

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
          AppLogger.debug('AuthLink getToken called, token present: ${token != null}');
          return token != null ? 'Bearer $token' : '';
        },
      );

      // For now, just use HTTP link without WebSocket to avoid blocking
      // WebSocket can be added later when needed for subscriptions
      final Link link = authLink.concat(httpLink);

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

      // If initialization fails, create a basic client without cache
      final HttpLink httpLink = HttpLink(
        graphqlEndpoint,
        defaultHeaders: {
          'Content-Type': 'application/json',
        },
      );

      final AuthLink authLink = AuthLink(
        getToken: () async {
          final token = await StorageService.getAuthToken();
          AppLogger.debug('AuthLink getToken called (fallback), token present: ${token != null}');
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
