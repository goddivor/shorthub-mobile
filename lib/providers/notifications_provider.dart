// lib/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../core/models/notification.dart';
import '../core/services/notifications_service.dart';
import '../core/graphql/graphql_client.dart';
import '../core/graphql/subscriptions.dart';
import '../core/utils/logger.dart';
import 'auth_provider.dart';

// Service Provider
final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService();
});

// All Notifications Provider
final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final service = ref.read(notificationsServiceProvider);
  return await service.getNotifications(first: 50);
});

// Unread Count Provider
final unreadNotificationsCountProvider = FutureProvider<int>((ref) async {
  final service = ref.read(notificationsServiceProvider);
  return await service.getUnreadCount();
});

// Notification Subscription Stream Provider
final notificationSubscriptionProvider = StreamProvider<AppNotification>((ref) {
  final userState = ref.watch(currentUserProvider);
  final user = userState.valueOrNull;

  if (user == null) {
    return const Stream.empty();
  }

  final client = GraphQLClientService.client;
  final operation = SubscriptionOptions(
    document: gql(notificationReceivedSubscription),
    variables: {'userId': user.id},
  );

  return client.subscribe(operation).where((result) {
    if (result.hasException) {
      AppLogger.error('Notification subscription error: ${result.exception}');
      return false;
    }
    return result.data != null && result.data!['notificationReceived'] != null;
  }).map((result) {
    final notification = AppNotification.fromJson(result.data!['notificationReceived']);
    // Invalidate cached providers to refresh lists
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationsCountProvider);
    return notification;
  });
});
