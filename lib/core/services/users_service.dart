// lib/core/services/users_service.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/user.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../utils/logger.dart';

class UsersService {
  // Use a getter instead of a final field to always get the latest client
  GraphQLClient get _client => GraphQLClientService.client;

  /// Fetch all users
  Future<List<User>> getAllUsers() async {
    AppLogger.graphqlQuery('getAllUsers', null);

    final QueryOptions options = QueryOptions(
      document: gql(usersQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getAllUsers', result.exception);
      throw Exception(result.exception.toString());
    }

    final edges = result.data?['users']?['edges'] as List<dynamic>?;
    if (edges == null) return [];

    AppLogger.graphqlSuccess('getAllUsers', 'Received ${edges.length} users');

    return edges
        .map((edge) => User.fromJson(edge['node'] as Map<String, dynamic>))
        .toList();
  }

  /// Fetch users by role
  Future<List<User>> getUsersByRole(String role) async {
    AppLogger.graphqlQuery('getUsersByRole', {'role': role});

    final QueryOptions options = QueryOptions(
      document: gql(usersQuery),
      variables: {'role': role},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getUsersByRole', result.exception);
      throw Exception(result.exception.toString());
    }

    final edges = result.data?['users']?['edges'] as List<dynamic>?;
    if (edges == null) return [];

    AppLogger.graphqlSuccess('getUsersByRole', 'Received ${edges.length} users with role $role');

    return edges
        .map((edge) => User.fromJson(edge['node'] as Map<String, dynamic>))
        .toList();
  }

  /// Get all videastes
  Future<List<User>> getVideastes() async {
    return await getUsersByRole('VIDEASTE');
  }

  /// Get all assistants
  Future<List<User>> getAssistants() async {
    return await getUsersByRole('ASSISTANT');
  }

  /// Create a user
  Future<User> createUser({
    required String username,
    required String password,
    String? email,
    required String role,
  }) async {
    AppLogger.graphqlMutation('createUser', {
      'username': username,
      'password': '***',
      if (email != null) 'email': email,
      'role': role,
    });

    final MutationOptions options = MutationOptions(
      document: gql(createUserMutation),
      variables: {
        'input': {
          'username': username,
          'password': password,
          if (email != null) 'email': email,
          'role': role,
        }
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('createUser', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('createUser', 'User created: $username with role $role');

    return User.fromJson(result.data!['createUser']);
  }

  /// Update user status
  Future<User> updateUserStatus(String userId, String status) async {
    AppLogger.graphqlMutation('updateUserStatus', {
      'id': userId,
      'status': status,
    });

    final MutationOptions options = MutationOptions(
      document: gql(updateUserStatusMutation),
      variables: {
        'id': userId,
        'status': status,
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('updateUserStatus', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('updateUserStatus', 'User status updated to $status');

    return User.fromJson(result.data!['updateUserStatus']);
  }

  /// Delete a user
  Future<bool> deleteUser(String userId) async {
    AppLogger.graphqlMutation('deleteUser', {'id': userId});

    final MutationOptions options = MutationOptions(
      document: gql(deleteUserMutation),
      variables: {'id': userId},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('deleteUser', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('deleteUser', 'User deleted successfully');

    return result.data!['deleteUser'] == true;
  }
}
