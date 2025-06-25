// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

import 'providers/app_providers.dart';
import 'screens/main_screen.dart';
import 'screens/initialization_screen.dart';
import 'theme/app_theme.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables first
    await dotenv.load(fileName: "assets/.env");
    
    // Initialize Supabase immediately
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    
    if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
      await SupabaseService.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      print('✅ Supabase initialized successfully');
    } else {
      print('❌ Supabase credentials not found in .env file');
    }
  } catch (e) {
    print('❌ Error during initialization: $e');
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription _intentMediaStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initSharingIntent();
  }

  void _initSharingIntent() {
    // Listen for shared media files (this includes URLs shared from YouTube)
    _intentMediaStreamSubscription =
        ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          // Handle shared content - extract URL from shared media
          for (var file in value) {
            if (file.path.contains('youtube.com') || 
                file.path.contains('youtu.be')) {
              _handleSharedUrl(file.path);
              break;
            }
          }
        }
      },
      onError: (err) => debugPrint('Error in media sharing stream: $err'),
    );

    // Handle initial shared content when app is launched via sharing
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        for (var file in value) {
          if (file.path.contains('youtube.com') || 
              file.path.contains('youtu.be')) {
            _handleSharedUrl(file.path);
            break;
          }
        }
      }
    });
  }

  void _handleSharedUrl(String sharedUrl) {
    debugPrint('Received shared YouTube URL: $sharedUrl');
    
    // Set the shared URL in provider and navigate to form tab
    ref.read(sharedUrlProvider.notifier).setUrl(sharedUrl);
    ref.read(mainTabProvider.notifier).state = 1; // Switch to form tab
  }

  @override
  void dispose() {
    _intentMediaStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ShortHub',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: AppInitializationWrapper(),
        );
      },
    );
  }
}

/// Wrapper to handle app initialization and show appropriate screen
class AppInitializationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInitState = ref.watch(appInitProvider);

    return appInitState.when(
      data: (isInitialized) {
        if (isInitialized) {
          return MainScreen();
        } else {
          return InitializationScreen(
            onRetry: () {
              ref.invalidate(appInitProvider);
            },
          );
        }
      },
      loading: () => InitializationScreen(),
      error: (error, stackTrace) => InitializationScreen(
        error: error.toString(),
        onRetry: () {
          ref.invalidate(appInitProvider);
        },
      ),
    );
  }
}

/// Utility to handle system UI overlay style
class SystemUIManager {
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  static void setTransparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }
}