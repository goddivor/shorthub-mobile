// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_routes.dart';
import 'core/graphql/graphql_client.dart';
import 'core/services/storage_service.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

/// Global navigator key for deep-linking from push notifications
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ShortHubApp extends ConsumerStatefulWidget {
  const ShortHubApp({super.key});

  @override
  ConsumerState<ShortHubApp> createState() => _ShortHubAppState();
}

class _ShortHubAppState extends ConsumerState<ShortHubApp> {
  @override
  void initState() {
    super.initState();
    GraphQLClientService.onAuthFailure = _handleAuthFailure;
  }

  void _handleAuthFailure() {
    StorageService.clearAuthTokens();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return GraphQLProvider(
      client: GraphQLClientService.clientNotifier,
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone 13 design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'ShortHub',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr'),
              Locale('en'),
            ],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
