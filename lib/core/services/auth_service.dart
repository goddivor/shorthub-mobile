// lib/core/services/auth_service.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../models/auth_payload.dart';
import '../models/user.dart';
import 'storage_service.dart';
import '../utils/logger.dart';

class AuthService {
  // Use a getter instead of a final field to always get the latest client
  GraphQLClient get _client => GraphQLClientService.client;

  /// Login with username and password
  Future<AuthPayload> login(String username, String password) async {
    try {
      AppLogger.graphqlMutation('login', {
        'username': username,
        'password': '***',
      });

      final result = await _client.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'username': username,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        AppLogger.graphqlError('login', result.exception);
        throw _handleException(result.exception!);
      }

      final data = result.data?['login'];
      if (data == null) {
        AppLogger.error('Login failed: No data returned');
        throw Exception('Login failed: No data returned');
      }

      final authPayload = AuthPayload.fromJson(data);

      // Save tokens and user data
      await StorageService.setAuthToken(authPayload.token);
      await StorageService.setRefreshToken(authPayload.refreshToken);
      await StorageService.setUser(authPayload.user);

      // Update GraphQL client with new token
      await GraphQLClientService.updateAuthToken(authPayload.token);

      AppLogger.graphqlSuccess('login', 'User logged in: $username with role ${authPayload.user.role}');

      return authPayload;
    } catch (e) {
      AppLogger.error('Login error', e);
      throw Exception('Login error: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      AppLogger.graphqlMutation('logout', null);

      // Call logout mutation
      await _client.mutate(
        MutationOptions(
          document: gql(logoutMutation),
        ),
      );

      AppLogger.graphqlSuccess('logout', 'User logged out successfully');
    } catch (e) {
      AppLogger.warning('Logout mutation failed, continuing with local cleanup');
      // Continue logout even if mutation fails
    } finally {
      // Clear local storage
      await StorageService.clearAuthTokens();
      await GraphQLClientService.clearCache();
      await GraphQLClientService.updateAuthToken(null);
      AppLogger.info('Auth tokens and cache cleared');
    }
  }

  /// Get current user
  Future<User?> getCurrentUser() async {
    try {
      // First check local storage
      final cachedUser = await StorageService.getUser();
      if (cachedUser != null) {
        AppLogger.debug('User found in cache: ${cachedUser.username}');
        return cachedUser;
      }

      AppLogger.graphqlQuery('me', null);

      // If not in cache, fetch from server
      final result = await _client.query(
        QueryOptions(
          document: gql(meQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        AppLogger.graphqlError('me', result.exception);
        throw _handleException(result.exception!);
      }

      final data = result.data?['me'];
      if (data == null) {
        AppLogger.warning('No user data returned from me query');
        return null;
      }

      final user = User.fromJson(data);

      // Cache user data
      await StorageService.setUser(user);

      AppLogger.graphqlSuccess('me', 'Current user fetched: ${user.username}');

      return user;
    } catch (e) {
      AppLogger.error('Get current user error', e);
      throw Exception('Get current user error: $e');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await StorageService.getAuthToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      // Verify token by fetching current user
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      // If fetch fails, token is invalid
      await StorageService.clearAuthTokens();
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      AppLogger.graphqlMutation('changePassword', {
        'oldPassword': '***',
        'newPassword': '***',
      });

      final result = await _client.mutate(
        MutationOptions(
          document: gql(changePasswordMutation),
          variables: {
            'oldPassword': oldPassword,
            'newPassword': newPassword,
          },
        ),
      );

      if (result.hasException) {
        AppLogger.graphqlError('changePassword', result.exception);
        throw _handleException(result.exception!);
      }

      final success = result.data?['changePassword'] ?? false;

      if (success) {
        AppLogger.graphqlSuccess('changePassword', 'Password changed successfully');
      } else {
        AppLogger.warning('Password change returned false');
      }

      return success;
    } catch (e) {
      AppLogger.error('Change password error', e);
      throw Exception('Change password error: $e');
    }
  }

  /// Refresh token
  Future<String?> refreshToken() async {
    try {
      final currentRefreshToken = await StorageService.getRefreshToken();
      if (currentRefreshToken == null) {
        AppLogger.warning('No refresh token available');
        return null;
      }

      AppLogger.graphqlMutation('refreshToken', {'token': '***'});

      final result = await _client.mutate(
        MutationOptions(
          document: gql(refreshTokenMutation),
          variables: {'token': currentRefreshToken},
        ),
      );

      if (result.hasException) {
        AppLogger.graphqlError('refreshToken', result.exception);
        return null;
      }

      final data = result.data?['refreshToken'];
      if (data == null) {
        AppLogger.warning('Refresh token returned no data');
        return null;
      }

      final authPayload = AuthPayload.fromJson(data);

      await StorageService.setAuthToken(authPayload.token);
      await StorageService.setRefreshToken(authPayload.refreshToken);
      await StorageService.setUser(authPayload.user);
      await GraphQLClientService.updateAuthToken(authPayload.token);

      AppLogger.graphqlSuccess('refreshToken', 'Token refreshed successfully');
      return authPayload.token;
    } catch (e) {
      AppLogger.error('Refresh token error', e);
      return null;
    }
  }

  /// Check if an exception is an authentication error
  static bool isAuthError(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      final code = exception.graphqlErrors.first.extensions?['code'];
      return code == 'UNAUTHENTICATED' || code == 'FORBIDDEN';
    }
    return false;
  }

  /// Handle GraphQL exceptions
  Exception _handleException(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      final error = exception.graphqlErrors.first;
      final message = error.message;

      if (isAuthError(exception)) {
        StorageService.clearAuthTokens();
        return Exception('Session expiree. Veuillez vous reconnecter.');
      }

      return Exception(message);
    }

    if (exception.linkException != null) {
      return Exception('Erreur reseau. Verifiez votre connexion.');
    }

    return Exception('Une erreur inconnue est survenue');
  }
}
