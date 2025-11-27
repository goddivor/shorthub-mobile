// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/graphql/graphql_client.dart';
import 'core/services/storage_service.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    logger.i('✅ Environment variables loaded');

    // Initialize storage
    await StorageService.initialize();
    logger.i('✅ Storage service initialized');

    // Initialize GraphQL client
    await GraphQLClientService.initialize();
    logger.i('✅ GraphQL client initialized');

    logger.i('🚀 ShortHub app starting...');
  } catch (e, stackTrace) {
    logger.e('❌ Error during initialization', error: e, stackTrace: stackTrace);
  }

  runApp(
    const ProviderScope(
      child: ShortHubApp(),
    ),
  );
}

// TODO: YouTube share intent handler will be re-implemented later
// This was the old implementation with Supabase
// It will be adapted to work with the new GraphQL backend