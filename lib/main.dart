// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';

import 'providers/app_providers.dart';
import 'screens/sharing_overlay_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
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
  late StreamSubscription _intentTextStreamSubscription;
  late StreamSubscription _intentMediaStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initSharingIntent();
  }

  void _initSharingIntent() {
    // Listen for shared text (URLs)
    // _intentTextStreamSubscription = ReceiveSharingIntent.instance.getTextStream().listen(
    //   (String value) {
    //     if (value.isNotEmpty) {
    //       _handleSharedText(value);
    //     }
    //   },
    //   onError: (err) => debugPrint('Error in text sharing stream: $err'),
    // );

    // Listen for shared media files (if needed in future)
    _intentMediaStreamSubscription =
        ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        // Handle shared media files if needed
        debugPrint('Shared media files: ${value.map((f) => f.path)}');
      },
      onError: (err) => debugPrint('Error in media sharing stream: $err'),
    );

    // Handle initial shared content when app is launched
    // ReceiveSharingIntent.instance.getInitialText().then((String? value) {
    //   if (value != null && value.isNotEmpty) {
    //     _handleSharedText(value);
    //   }
    // });

    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        // Handle initial shared media if needed
        debugPrint('Initial shared media: ${value.map((f) => f.path)}');
      }
    });
  }

  // void _handleSharedText(String sharedText) {
  //   debugPrint('Received shared text: $sharedText');

  //   // Update shared URL in provider
  //   ref.read(sharedUrlProvider.notifier).setUrl(sharedText);

  //   // Process the shared URL
  //   ref.read(shareIntentProvider.notifier).processSharedUrl(sharedText);
  // }

  @override
  void dispose() {
    _intentTextStreamSubscription.cancel();
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
          home: AppRouter(),
        );
      },
    );
  }
}

/// Router widget that determines which screen to show
class AppRouter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for shared URLs
    final sharedUrl = ref.watch(sharedUrlProvider);
    final shareIntentData = ref.watch(shareIntentProvider);

    // If we have a shared URL, show the overlay
    if (sharedUrl != null) {
      return SharingOverlayScreen();
    }

    // Otherwise show the home screen
    return HomeScreen();
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
