// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_routes.dart';
import 'core/graphql/graphql_client.dart';
import 'providers/theme_provider.dart';

class ShortHubApp extends ConsumerWidget {
  const ShortHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

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
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
