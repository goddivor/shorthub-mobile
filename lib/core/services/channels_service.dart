// lib/core/services/channels_service.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/source_channel.dart';
import '../models/admin_channel.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../utils/logger.dart';

class ChannelsService {
  // Use a getter instead of a final field to always get the latest client
  GraphQLClient get _client => GraphQLClientService.client;

  /// Fetch all source channels
  Future<List<SourceChannel>> getSourceChannels() async {
    AppLogger.graphqlQuery('getSourceChannels', null);

    final QueryOptions options = QueryOptions(
      document: gql(sourceChannelsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getSourceChannels', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('getSourceChannels', 'Received ${result.data?['sourceChannels']?.length ?? 0} source channels');

    final List<dynamic>? data = result.data?['sourceChannels'];
    if (data == null) return [];

    return data.map((json) => SourceChannel.fromJson(json)).toList();
  }

  /// Create a source channel
  Future<SourceChannel> createSourceChannel({
    required String channelId,
    required String channelName,
    required String contentType,
    String? profileImageUrl,
  }) async {
    AppLogger.graphqlMutation('createSourceChannel', {
      'channelId': channelId,
      'channelName': channelName,
      'contentType': contentType,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    });

    final MutationOptions options = MutationOptions(
      document: gql(createSourceChannelMutation),
      variables: {
        'channelId': channelId,
        'channelName': channelName,
        'contentType': contentType,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('createSourceChannel', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('createSourceChannel', 'Source channel created: $channelName');

    return SourceChannel.fromJson(result.data!['createSourceChannel']);
  }

  /// Update a source channel
  Future<SourceChannel> updateSourceChannel({
    required String id,
    String? channelName,
    String? contentType,
    String? profileImageUrl,
  }) async {
    AppLogger.graphqlMutation('updateSourceChannel', {
      'id': id,
      if (channelName != null) 'channelName': channelName,
      if (contentType != null) 'contentType': contentType,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    });

    final MutationOptions options = MutationOptions(
      document: gql(updateSourceChannelMutation),
      variables: {
        'id': id,
        if (channelName != null) 'channelName': channelName,
        if (contentType != null) 'contentType': contentType,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('updateSourceChannel', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('updateSourceChannel', 'Source channel updated successfully');

    return SourceChannel.fromJson(result.data!['updateSourceChannel']);
  }

  /// Delete a source channel
  Future<bool> deleteSourceChannel(String id) async {
    AppLogger.graphqlMutation('deleteSourceChannel', {'id': id});

    final MutationOptions options = MutationOptions(
      document: gql(deleteSourceChannelMutation),
      variables: {'id': id},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('deleteSourceChannel', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('deleteSourceChannel', 'Source channel deleted successfully');

    return result.data!['deleteSourceChannel'] == true;
  }

  /// Fetch all admin channels
  Future<List<AdminChannel>> getAdminChannels() async {
    AppLogger.graphqlQuery('getAdminChannels', null);

    final QueryOptions options = QueryOptions(
      document: gql(adminChannelsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getAdminChannels', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('getAdminChannels', 'Received ${result.data?['adminChannels']?.length ?? 0} admin channels');

    final List<dynamic>? data = result.data?['adminChannels'];
    if (data == null) return [];

    return data.map((json) => AdminChannel.fromJson(json)).toList();
  }

  /// Create an admin channel
  Future<AdminChannel> createAdminChannel({
    required String channelId,
    required String channelName,
    String? profileImageUrl,
  }) async {
    AppLogger.graphqlMutation('createAdminChannel', {
      'channelId': channelId,
      'channelName': channelName,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    });

    final MutationOptions options = MutationOptions(
      document: gql(createAdminChannelMutation),
      variables: {
        'channelId': channelId,
        'channelName': channelName,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      },
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('createAdminChannel', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('createAdminChannel', 'Admin channel created: $channelName');

    return AdminChannel.fromJson(result.data!['createAdminChannel']);
  }

  /// Delete an admin channel
  Future<bool> deleteAdminChannel(String id) async {
    AppLogger.graphqlMutation('deleteAdminChannel', {'id': id});

    final MutationOptions options = MutationOptions(
      document: gql(deleteAdminChannelMutation),
      variables: {'id': id},
    );

    final result = await _client.mutate(options);

    if (result.hasException) {
      AppLogger.graphqlError('deleteAdminChannel', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('deleteAdminChannel', 'Admin channel deleted successfully');

    return result.data!['deleteAdminChannel'] == true;
  }
}
