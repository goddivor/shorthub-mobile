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

  /// Refresh token (if needed)
  Future<String?> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) {
        return null;
      }

      // TODO: Implement refresh token mutation when backend supports it
      // For now, just return the existing token
      return await StorageService.getAuthToken();
    } catch (e) {
      throw Exception('Refresh token error: $e');
    }
  }

  /// Handle GraphQL exceptions
  Exception _handleException(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      final error = exception.graphqlErrors.first;
      final message = error.message;

      // Check for authentication errors
      if (error.extensions?['code'] == 'UNAUTHENTICATED' ||
          error.extensions?['code'] == 'FORBIDDEN') {
        StorageService.clearAuthTokens();
        return Exception('Session expired. Please login again.');
      }

      return Exception(message);
    }

    if (exception.linkException != null) {
      return Exception('Network error. Please check your connection.');
    }

    return Exception('An unknown error occurred');
  }
}
