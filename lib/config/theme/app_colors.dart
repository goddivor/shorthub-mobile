// lib/config/theme/app_colors.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// App color palette aligned with web version
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF3B82F6); // Blue
  static const Color secondary = Color(0xFF8B5CF6); // Purple
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Yellow/Orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF6366F1); // Indigo

  // Neutral Colors
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Short Status Colors
  static const Color statusRolled = Color(0xFF6B7280); // Gray
  static const Color statusRetained = Color(0xFF3B82F6); // Blue
  static const Color statusAssigned = Color(0xFF8B5CF6); // Purple
  static const Color statusInProgress = Color(0xFFF59E0B); // Orange
  static const Color statusCompleted = Color(0xFF10B981); // Green
  static const Color statusValidated = Color(0xFF06B6D4); // Cyan
  static const Color statusPublished = Color(0xFF14B8A6); // Teal
  static const Color statusRejected = Color(0xFFEF4444); // Red

  // Backgrounds
  static const Color background = Color(0xFFF9FAFB); // Default light background
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFF9FAFB);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Get status color by status
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ROLLED':
        return statusRolled;
      case 'RETAINED':
        return statusRetained;
      case 'ASSIGNED':
        return statusAssigned;
      case 'IN_PROGRESS':
        return statusInProgress;
      case 'COMPLETED':
        return statusCompleted;
      case 'VALIDATED':
        return statusValidated;
      case 'PUBLISHED':
        return statusPublished;
      case 'REJECTED':
        return statusRejected;
      default:
        return gray500;
    }
  }

  // Get status background color (lighter version)
  static Color getStatusBackgroundColor(String status) {
    return getStatusColor(status).withOpacity(0.1);
  }
}
