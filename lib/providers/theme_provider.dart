// lib/providers/theme_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/storage_service.dart';

enum AppThemeMode { light, dark, black }

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final stored = StorageService.getThemeMode();
    switch (stored) {
      case 'dark':
        state = AppThemeMode.dark;
      case 'black':
        state = AppThemeMode.black;
      default:
        state = AppThemeMode.light;
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await StorageService.setThemeMode(mode.name);
  }

  Future<void> toggle() async {
    final newMode =
        state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setTheme(newMode);
  }

  bool get isDark => state != AppThemeMode.light;
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  (ref) => ThemeModeNotifier(),
);
