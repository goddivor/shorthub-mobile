// lib/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/notification.dart';
import '../core/services/notifications_service.dart';

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
