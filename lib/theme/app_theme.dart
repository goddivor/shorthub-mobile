// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shorthub/models/channel_models.dart';

/// YouTube-inspired color palette and theme
class AppColors {
  // YouTube brand colors
  static const Color youtubeRed = Color(0xFFFF0000);
  static const Color youtubeRedDark = Color(0xFFCC0000);
  static const Color youtubeRedLight = Color(0xFFFF3333);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkSecondary = Color(0xFFB0B0B0);
  
  // Success, warning, error colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Tag colors (matching web app)
  static const Color tagVF = Color(0xFFDC2626); // red
  static const Color tagVOSTFR = Color(0xFF2563EB); // blue
  static const Color tagVA = Color(0xFFEAB308); // yellow
  static const Color tagVOSTA = Color(0xFF7C3AED); // purple
  static const Color tagVO = Color(0xFF059669); // green
  
  // Type colors
  static const Color typeMix = Color(0xFF3B82F6); // blue
  static const Color typeOnly = Color(0xFF10B981); // green
  
  // Overlay colors
  static const Color overlayBackground = Color(0x80000000);
  static const Color bottomSheetHandle = Color(0xFFE0E0E0);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.youtubeRed,
        brightness: Brightness.light,
        primary: AppColors.youtubeRed,
        secondary: AppColors.youtubeRedLight,
        surface: AppColors.surfaceLight,
        background: AppColors.backgroundLight,
        error: AppColors.error,
      ),
      
      // Text theme using Space Grotesk (matching web app)
      textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelSmall: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.youtubeRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.youtubeRed,
          side: const BorderSide(color: AppColors.youtubeRed, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.youtubeRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.youtubeRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.youtubeRed,
        brightness: Brightness.dark,
        primary: AppColors.youtubeRed,
        secondary: AppColors.youtubeRedLight,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
        error: AppColors.error,
      ),
      
      // Update text colors for dark theme
      textTheme: lightTheme.textTheme.copyWith(
        displayLarge: lightTheme.textTheme.displayLarge?.copyWith(
          color: AppColors.textOnDark,
        ),
        displayMedium: lightTheme.textTheme.displayMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        displaySmall: lightTheme.textTheme.displaySmall?.copyWith(
          color: AppColors.textOnDark,
        ),
        headlineLarge: lightTheme.textTheme.headlineLarge?.copyWith(
          color: AppColors.textOnDark,
        ),
        headlineMedium: lightTheme.textTheme.headlineMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        headlineSmall: lightTheme.textTheme.headlineSmall?.copyWith(
          color: AppColors.textOnDark,
        ),
        titleLarge: lightTheme.textTheme.titleLarge?.copyWith(
          color: AppColors.textOnDark,
        ),
        titleMedium: lightTheme.textTheme.titleMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        titleSmall: lightTheme.textTheme.titleSmall?.copyWith(
          color: AppColors.textOnDark,
        ),
        bodyLarge: lightTheme.textTheme.bodyLarge?.copyWith(
          color: AppColors.textOnDark,
        ),
        bodyMedium: lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        bodySmall: lightTheme.textTheme.bodySmall?.copyWith(
          color: AppColors.textOnDarkSecondary,
        ),
        labelLarge: lightTheme.textTheme.labelLarge?.copyWith(
          color: AppColors.textOnDark,
        ),
        labelMedium: lightTheme.textTheme.labelMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        labelSmall: lightTheme.textTheme.labelSmall?.copyWith(
          color: AppColors.textOnDarkSecondary,
        ),
      ),
      
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textOnDark,
      ),
      
      cardTheme: lightTheme.cardTheme.copyWith(
        color: AppColors.surfaceDark,
      ),
      
      bottomSheetTheme: lightTheme.bottomSheetTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
      ),
      
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: AppColors.surfaceDark,
        labelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.textOnDarkSecondary,
        ),
        hintStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: AppColors.textOnDarkSecondary,
        ),
      ),
    );
  }
}

/// Extension to get tag-specific colors
extension TagTypeColors on TagType {
  Color get color {
    switch (this) {
      case TagType.vf:
        return AppColors.tagVF;
      case TagType.vostfr:
        return AppColors.tagVOSTFR;
      case TagType.va:
        return AppColors.tagVA;
      case TagType.vosta:
        return AppColors.tagVOSTA;
      case TagType.vo:
        return AppColors.tagVO;
    }
  }
  
  Color get backgroundColor {
    return color.withOpacity(0.1);
  }
}

/// Extension to get type-specific colors
extension ChannelTypeColors on ChannelType {
  Color get color {
    switch (this) {
      case ChannelType.mix:
        return AppColors.typeMix;
      case ChannelType.only:
        return AppColors.typeOnly;
    }
  }
  
  Color get backgroundColor {
    return color.withOpacity(0.1);
  }
}