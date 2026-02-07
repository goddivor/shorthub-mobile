// lib/core/services/shorts_service.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/short.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../utils/logger.dart';

class ShortsService {
  // Use a getter instead of a final field to always get the latest client
  GraphQLClient get _client => GraphQLClientService.client;

  /// Fetch all shorts
  Future<List<Short>> getAllShorts() async {
    AppLogger.graphqlQuery('getAllShorts', null);

    final QueryOptions options = QueryOptions(
      document: gql(shortsQuery),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getAllShorts', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('getAllShorts', 'Received ${result.data?['shorts']?.length ?? 0} shorts');

    final List<dynamic>? data = result.data?['shorts'];
    if (data == null) return [];

    try {
      // Log first item to see the structure
      if (data.isNotEmpty) {
        AppLogger.debug('First short data: ${data.first}');
      }

      return data.map((json) => Short.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error parsing shorts JSON', e, stackTrace);
      throw Exception('Failed to parse shorts: $e');
    }
  }

  /// Fetch shorts by status
  Future<List<Short>> getShortsByStatus(String status) async {
    AppLogger.graphqlQuery('getShortsByStatus', {'status': status});

    final QueryOptions options = QueryOptions(
      document: gql(shortsQuery),
      variables: {'status': status},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getShortsByStatus', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('getShortsByStatus', 'Received ${result.data?['shorts']?.length ?? 0} shorts with status $status');

    final List<dynamic>? data = result.data?['shorts'];
    if (data == null) return [];

    return data.map((json) => Short.fromJson(json)).toList();
  }

  /// Fetch shorts assigned to current user
  Future<List<Short>> getMyAssignedShorts() async {
    AppLogger.graphqlQuery('getMyAssignedShorts', {'assignedToMe': true});

    final QueryOptions options = QueryOptions(
      document: gql(shortsQuery),
      variables: {'assignedToMe': true},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getMyAssignedShorts', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('getMyAssignedShorts', 'Received ${result.data?['shorts']?.length ?? 0} assigned shorts');

    final List<dynamic>? data = result.data?['shorts'];
    if (data == null) return [];

    return data.map((json) => Short.fromJson(json)).toList();
  }

  /// Roll a short (admin action)
  Future<Short> rollShort(String videoId) async {
    AppLogger.graphqlMutation('rollShort', {'videoId': videoId});

    final MutationOptions options = MutationOptions(
      document: gql(rollShortMutation),
      variables: {'videoId': videoId},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('rollShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('rollShort', 'Short rolled successfully');

    return Short.fromJson(result.data!['rollShort']);
  }

  /// Assign a short to a videaste
  Future<Short> assignShort(String shortId, String videasteId) async {
    AppLogger.graphqlMutation('assignShort', {
      'shortId': shortId,
      'videasteId': videasteId,
    });

    final MutationOptions options = MutationOptions(
      document: gql(assignShortMutation),
      variables: {
        'shortId': shortId,
        'videasteId': videasteId,
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('assignShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('assignShort', 'Short assigned successfully');

    return Short.fromJson(result.data!['assignShort']);
  }

  /// Update short status
  Future<Short> updateShortStatus(
    String shortId,
    String status, {
    String? adminFeedback,
    bool? deleteFile,
  }) async {
    final input = <String, dynamic>{
      'shortId': shortId,
      'status': status,
      if (adminFeedback != null) 'adminFeedback': adminFeedback,
      if (deleteFile != null) 'deleteFile': deleteFile,
    };

    AppLogger.graphqlMutation('updateShortStatus', input);

    final MutationOptions options = MutationOptions(
      document: gql(updateShortStatusMutation),
      variables: {'input': input},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('updateShortStatus', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('updateShortStatus', 'Short status updated to $status');

    return Short.fromJson(result.data!['updateShortStatus']);
  }

  /// Validate a short (assistant action)
  Future<Short> validateShort(String shortId, {String? feedback}) async {
    return updateShortStatus(shortId, 'VALIDATED', adminFeedback: feedback);
  }

  /// Reject a short (assistant action)
  Future<Short> rejectShort(String shortId, String reason) async {
    return updateShortStatus(shortId, 'REJECTED', adminFeedback: reason);
  }

  /// Delete a short
  Future<bool> deleteShort(String shortId) async {
    AppLogger.graphqlMutation('deleteShort', {'shortId': shortId});

    final MutationOptions options = MutationOptions(
      document: gql(deleteShortMutation),
      variables: {'shortId': shortId},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('deleteShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('deleteShort', 'Short deleted successfully');

    return result.data!['deleteShort'] == true;
  }
}
