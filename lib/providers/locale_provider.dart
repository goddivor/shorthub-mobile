// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/storage_service.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fr')) {
    _loadLocale();
  }

  void _loadLocale() {
    final stored = StorageService.getString('locale');
    if (stored == 'en') {
      state = const Locale('en');
    } else {
      state = const Locale('fr');
    }
  }

  Future<void> toggle() async {
    final newLocale = state.languageCode == 'fr'
        ? const Locale('en')
        : const Locale('fr');
    state = newLocale;
    await StorageService.setString('locale', newLocale.languageCode);
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await StorageService.setString('locale', languageCode);
  }

  bool get isFrench => state.languageCode == 'fr';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
