// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'app.dart';
import 'core/graphql/graphql_client.dart';
import 'core/services/storage_service.dart';
import 'core/services/push_notification_service.dart';
import 'features/share_overlay/share_overlay_app.dart';

final logger = Logger();

/// Regex to extract YouTube URLs (videos, shorts, channels)
final _youtubeRegex = RegExp(
  r'(https?://)?(www\.)?(youtube\.com|youtu\.be)(/shorts/|/watch\?v=|/channel/|/c/|/@)[\w\-]+',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? sharedYoutubeUrl;

  try {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Load environment variables
    await dotenv.load(fileName: "assets/.env");
    logger.i('Environment variables loaded');

    // Initialize storage
    await StorageService.initialize();
    logger.i('Storage service initialized');

    // Initialize GraphQL client
    await GraphQLClientService.initialize();
    logger.i('GraphQL client initialized');

    // Check for share intent before deciding which app to launch
    try {
      final sharedMedia = await ReceiveSharingIntent.instance.getInitialMedia();
      if (sharedMedia.isNotEmpty) {
        final sharedText = sharedMedia.first.path;
        final match = _youtubeRegex.firstMatch(sharedText);
        if (match != null) {
          sharedYoutubeUrl = match.group(0);
          logger.i('YouTube share intent detected: $sharedYoutubeUrl');
        }
      }
    } catch (e) {
      logger.w('Share intent check failed: $e');
    }

    // Only init Firebase for normal app launch (skip for overlay to stay fast)
    if (sharedYoutubeUrl == null) {
      try {
        await Firebase.initializeApp();
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
        await PushNotificationService().initialize();
        logger.i('Firebase & push notifications initialized');
      } catch (e) {
        logger.w('Firebase init skipped (configure google-services.json): $e');
      }
    }

    logger.i('ShortHub app starting...');
  } catch (e, stackTrace) {
    logger.e('Error during initialization', error: e, stackTrace: stackTrace);
  }

  // Branch: share overlay vs normal app
  if (sharedYoutubeUrl != null) {
    runApp(ShareOverlayApp(youtubeUrl: sharedYoutubeUrl));
  } else {
    runApp(
      const ProviderScope(
        child: ShortHubApp(),
      ),
    );
  }
}