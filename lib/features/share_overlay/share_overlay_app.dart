import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../config/theme/app_colors.dart';
import 'share_overlay_screen.dart';

class ShareOverlayApp extends StatelessWidget {
  final String youtubeUrl;

  const ShareOverlayApp({super.key, required this.youtubeUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShortHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: Colors.white,
          error: AppColors.error,
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.gray700,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.gray500,
          ),
        ),
      ),
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
      home: ShareOverlayScreen(youtubeUrl: youtubeUrl),
    );
  }
}
