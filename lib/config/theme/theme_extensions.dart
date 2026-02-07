// lib/config/theme/theme_extensions.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware color extension on BuildContext.
/// Usage: context.cardBg, context.textPrimary, etc.
extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Backgrounds
  Color get cardBg => isDark ? AppColors.surfaceDark : Colors.white;
  Color get subtleBg => isDark ? const Color(0xFF263148) : AppColors.gray50;
  Color get chipBg => isDark ? AppColors.gray800 : AppColors.gray100;

  // Text
  Color get textPrimary => isDark ? AppColors.gray100 : AppColors.gray900;
  Color get textSecondary => isDark ? AppColors.gray300 : AppColors.gray700;
  Color get textTertiary => isDark ? AppColors.gray400 : AppColors.gray600;
  Color get textHint => isDark ? AppColors.gray500 : AppColors.gray400;
  Color get textOnPrimary => Colors.white;

  // Borders & Dividers
  Color get borderColor => isDark ? AppColors.gray700 : AppColors.gray200;
  Color get dividerClr => isDark ? AppColors.gray700 : AppColors.gray200;

  // Icons
  Color get iconColor => isDark ? AppColors.gray300 : AppColors.gray700;
  Color get iconSubtle => isDark ? AppColors.gray500 : AppColors.gray400;
}
