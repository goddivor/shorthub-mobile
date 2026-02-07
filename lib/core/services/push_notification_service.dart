// lib/core/services/push_notification_service.dart
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import '../../app.dart';
import '../../config/routes/app_routes.dart';
import '../graphql/graphql_client.dart';
import '../graphql/mutations.dart';
import 'storage_service.dart';

final _logger = Logger();

/// Top-level background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _logger.d('Background message: ${message.messageId}');
}

/// Service for managing push notifications via Firebase Cloud Messaging
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._();
  factory PushNotificationService() => _instance;
  PushNotificationService._();

  static const String _fcmTokenKey = 'fcm_token';
  static const String _channelId = 'shorthub_notifications';
  static const String _channelName = 'ShortHub Notifications';
  static const String _channelDescription = 'Notifications for ShortHub app';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the push notification service
  /// Call this after Firebase.initializeApp()
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _logger.w('Push notification permission denied');
        return;
      }

      _logger.i('Push notification permission: ${settings.authorizationStatus}');

      // Initialize local notifications (for foreground display)
      await _initLocalNotifications();

      // Get and store FCM token
      await _retrieveAndStoreToken();

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      // Handle notification tap (app in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      // Handle notification that launched the app
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _onMessageOpenedApp(initialMessage);
      }

      // Set foreground notification presentation (iOS)
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      _initialized = true;
      _logger.i('Push notification service initialized');
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize push notifications', error: e, stackTrace: stackTrace);
    }
  }

  /// Initialize flutter_local_notifications for foreground display
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Retrieve FCM token and store locally, then send to backend
  Future<String?> _retrieveAndStoreToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await StorageService.setString(_fcmTokenKey, token);
        _logger.i('FCM token stored: ${token.substring(0, 20)}...');
        await _sendTokenToServer(token);
      }
      return token;
    } catch (e) {
      _logger.e('Failed to get FCM token', error: e);
      return null;
    }
  }

  /// Handle token refresh
  void _onTokenRefresh(String token) {
    StorageService.setString(_fcmTokenKey, token);
    _logger.i('FCM token refreshed');
    _sendTokenToServer(token);
  }

  /// Send FCM token to backend via GraphQL mutation
  Future<void> _sendTokenToServer(String token) async {
    try {
      final isAuth = await StorageService.isAuthenticated();
      if (!isAuth) {
        _logger.d('Not authenticated, skipping FCM token sync');
        return;
      }

      final result = await GraphQLClientService.client.mutate(
        MutationOptions(
          document: gql(updateFcmTokenMutation),
          variables: {'fcmToken': token},
        ),
      );

      if (result.hasException) {
        _logger.w('Failed to send FCM token to server: ${result.exception}');
      } else {
        _logger.i('FCM token synced with server');
      }
    } catch (e) {
      _logger.w('Failed to send FCM token to server: $e');
    }
  }

  /// Handle foreground messages - show local notification
  void _onForegroundMessage(RemoteMessage message) {
    _logger.d('Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap when app was in background
  void _onMessageOpenedApp(RemoteMessage message) {
    _logger.d('Notification opened app: ${message.data}');
    _handleNotificationNavigation(message.data);
  }

  /// Handle local notification tap
  void _onNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    try {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      _handleNotificationNavigation(data);
    } catch (e) {
      _logger.e('Failed to parse notification payload', error: e);
    }
  }

  /// Navigate based on notification data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    _logger.d('Notification navigation data: $data');

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final shortId = data['shortId'] as String?;
    final type = data['type'] as String?;

    // Navigate to short details for short-related notifications
    if (shortId != null) {
      navigator.pushNamed(AppRoutes.shortDetails, arguments: shortId);
      return;
    }

    // For account-related notifications, go to notifications screen
    if (type == 'ACCOUNT_BLOCKED' || type == 'ACCOUNT_UNBLOCKED') {
      navigator.pushNamed(AppRoutes.notifications);
      return;
    }
  }

  /// Get the stored FCM token
  String? get storedToken => StorageService.getString(_fcmTokenKey);

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e) {
      _logger.e('Failed to subscribe to topic: $topic', error: e);
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Failed to unsubscribe from topic: $topic', error: e);
    }
  }
}
