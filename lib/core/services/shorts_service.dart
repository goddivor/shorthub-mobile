// lib/core/services/shorts_service.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/short.dart';
import '../models/short_comment.dart';
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

  /// Fetch a single short by ID
  Future<Short> getShortById(String id) async {
    AppLogger.graphqlQuery('getShortById', {'id': id});

    final QueryOptions options = QueryOptions(
      document: gql(shortQuery),
      variables: {'id': id},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getShortById', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('getShortById', 'Short fetched');
    return Short.fromJson(result.data!['short']);
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

  /// Roll a short from a source channel (admin action)
  Future<Short> rollShort(String sourceChannelId) async {
    AppLogger.graphqlMutation('rollShort', {'sourceChannelId': sourceChannelId});

    final MutationOptions options = MutationOptions(
      document: gql(rollShortMutation),
      variables: {
        'input': {'sourceChannelId': sourceChannelId},
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('rollShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('rollShort', 'Short rolled successfully');
    return Short.fromJson(result.data!['rollShort']);
  }

  /// Retain a rolled short (admin action)
  Future<void> retainShort(String shortId) async {
    AppLogger.graphqlMutation('retainShort', {'shortId': shortId});

    final MutationOptions options = MutationOptions(
      document: gql(retainShortMutation),
      variables: {'shortId': shortId},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('retainShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('retainShort', 'Short retained successfully');
  }

  /// Reject a rolled short (admin action - can re-appear in rolls)
  Future<void> rejectRolledShort(String shortId) async {
    AppLogger.graphqlMutation('rejectShort', {'shortId': shortId});

    final MutationOptions options = MutationOptions(
      document: gql(rejectShortMutation),
      variables: {'shortId': shortId},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('rejectShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('rejectShort', 'Rolled short rejected');
  }

  /// Assign a short to a videaste (admin action)
  Future<void> assignShort({
    required String shortId,
    required String videasteId,
    required String targetChannelId,
    required DateTime deadline,
    String? notes,
  }) async {
    final input = <String, dynamic>{
      'shortId': shortId,
      'videasteId': videasteId,
      'targetChannelId': targetChannelId,
      'deadline': deadline.toIso8601String(),
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    AppLogger.graphqlMutation('assignShort', input);

    final MutationOptions options = MutationOptions(
      document: gql(assignShortMutation),
      variables: {'input': input},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('assignShort', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('assignShort', 'Short assigned successfully');
  }

  /// Get shorts stats from API
  Future<Map<String, int>> getShortsStats() async {
    AppLogger.graphqlQuery('shortsStats', null);

    final result = await _client.query(QueryOptions(
      document: gql(shortsStatsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException) {
      AppLogger.graphqlError('shortsStats', result.exception);
      throw Exception(result.exception.toString());
    }

    final data = result.data?['shortsStats'];
    if (data == null) return {};

    AppLogger.graphqlSuccess('shortsStats', 'Stats fetched');
    return {
      'totalRolled': data['totalRolled'] ?? 0,
      'totalRetained': data['totalRetained'] ?? 0,
      'totalRejected': data['totalRejected'] ?? 0,
      'totalAssigned': data['totalAssigned'] ?? 0,
      'totalInProgress': data['totalInProgress'] ?? 0,
      'totalCompleted': data['totalCompleted'] ?? 0,
      'totalValidated': data['totalValidated'] ?? 0,
      'totalPublished': data['totalPublished'] ?? 0,
    };
  }

  /// Update short status
  Future<void> updateShortStatus(
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
  }

  /// Validate a short (assistant action)
  Future<void> validateShort(String shortId, {String? feedback}) async {
    return updateShortStatus(shortId, 'VALIDATED', adminFeedback: feedback);
  }

  /// Reject a short (assistant action)
  Future<void> rejectShort(String shortId, String reason) async {
    return updateShortStatus(shortId, 'REJECTED', adminFeedback: reason);
  }

  /// Start working on a short (videaste action)
  Future<void> startWorkOnShort(String shortId) async {
    return updateShortStatus(shortId, 'IN_PROGRESS');
  }

  /// Mark a short as completed (videaste action)
  Future<void> completeShort(String shortId) async {
    return updateShortStatus(shortId, 'COMPLETED');
  }

  /// Publish a validated short (admin action)
  Future<void> publishShort(String shortId) async {
    return updateShortStatus(shortId, 'PUBLISHED');
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

  /// Create a comment on a short
  Future<ShortComment> createComment(String shortId, String comment) async {
    AppLogger.graphqlMutation('createShortComment', {'shortId': shortId});

    final MutationOptions options = MutationOptions(
      document: gql(createShortCommentMutation),
      variables: {
        'input': {
          'shortId': shortId,
          'comment': comment,
        },
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('createShortComment', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('createShortComment', 'Comment created');
    return ShortComment.fromJson(result.data!['createShortComment']);
  }
}
