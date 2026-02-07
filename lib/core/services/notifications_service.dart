// lib/core/services/notifications_service.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/notification.dart';
import '../graphql/graphql_client.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../utils/logger.dart';

class NotificationsService {
  GraphQLClient get _client => GraphQLClientService.client;

  /// Fetch all notifications
  Future<List<AppNotification>> getNotifications({int? first, bool? unreadOnly}) async {
    AppLogger.graphqlQuery('getNotifications', {'first': first, 'unreadOnly': unreadOnly});

    final QueryOptions options = QueryOptions(
      document: gql(notificationsQuery),
      variables: {
        if (first != null) 'first': first,
        if (unreadOnly != null) 'unreadOnly': unreadOnly,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      AppLogger.graphqlError('getNotifications', result.exception);
      throw Exception(result.exception.toString());
    }

    final edges = result.data?['notifications']?['edges'] as List<dynamic>?;
    if (edges == null) return [];

    AppLogger.graphqlSuccess('getNotifications', 'Received ${edges.length} notifications');
    return edges.map((e) => AppNotification.fromJson(e['node'])).toList();
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    AppLogger.graphqlQuery('unreadNotificationsCount', null);

    final result = await _client.query(QueryOptions(
      document: gql(unreadNotificationsCountQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException) {
      AppLogger.graphqlError('unreadNotificationsCount', result.exception);
      throw Exception(result.exception.toString());
    }

    final count = result.data?['unreadNotificationsCount'] ?? 0;
    AppLogger.graphqlSuccess('unreadNotificationsCount', 'Unread: $count');
    return count;
  }

  /// Mark a notification as read
  Future<void> markAsRead(String id) async {
    AppLogger.graphqlMutation('markNotificationAsRead', {'id': id});

    final result = await _client.mutate(MutationOptions(
      document: gql(markNotificationAsReadMutation),
      variables: {'id': id},
    ));

    if (result.hasException) {
      AppLogger.graphqlError('markNotificationAsRead', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('markNotificationAsRead', 'Marked as read');
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    AppLogger.graphqlMutation('markAllNotificationsAsRead', null);

    final result = await _client.mutate(MutationOptions(
      document: gql(markAllNotificationsAsReadMutation),
    ));

    if (result.hasException) {
      AppLogger.graphqlError('markAllNotificationsAsRead', result.exception);
      throw Exception(result.exception.toString());
    }

    AppLogger.graphqlSuccess('markAllNotificationsAsRead', 'All marked as read');
  }
}
