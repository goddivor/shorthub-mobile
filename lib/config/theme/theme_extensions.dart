// lib/config/theme/theme_extensions.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware color extension on BuildContext.
/// Usage: context.cardBg, context.textPrimary, etc.
extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isBlack =>
      isDark &&
      Theme.of(this).scaffoldBackgroundColor == AppColors.backgroundBlack;

  // Backgrounds
  Color get cardBg => isBlack
      ? AppColors.surfaceBlack
      : isDark
          ? AppColors.surfaceDark
          : Colors.white;

  Color get subtleBg => isBlack
      ? const Color(0xFF1A1A1A)
      : isDark
          ? const Color(0xFF263148)
          : AppColors.gray50;

  Color get chipBg => isBlack
      ? const Color(0xFF1E1E1E)
      : isDark
          ? AppColors.gray800
          : AppColors.gray100;

  // Text
  Color get textPrimary => isDark ? AppColors.gray100 : AppColors.gray900;
  Color get textSecondary => isDark ? AppColors.gray300 : AppColors.gray700;
  Color get textTertiary => isDark ? AppColors.gray400 : AppColors.gray600;
  Color get textHint => isDark ? AppColors.gray500 : AppColors.gray400;
  Color get textOnPrimary => Colors.white;

  // Borders & Dividers
  Color get borderColor => isBlack
      ? const Color(0xFF2A2A2A)
      : isDark
          ? AppColors.gray700
          : AppColors.gray200;

  Color get dividerClr => isBlack
      ? const Color(0xFF2A2A2A)
      : isDark
          ? AppColors.gray700
          : AppColors.gray200;

  // Icons
  Color get iconColor => isDark ? AppColors.gray300 : AppColors.gray700;
  Color get iconSubtle => isDark ? AppColors.gray500 : AppColors.gray400;
}
