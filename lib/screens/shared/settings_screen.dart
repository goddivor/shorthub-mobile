// lib/screens/shared/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        backgroundColor: context.cardBg,
        elevation: 0,
        iconTheme: IconThemeData(color: context.iconColor),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Appearance section
          _buildSectionHeader(context, l10n.settingsAppearance),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              children: [
                // Theme selector
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      currentTheme == AppThemeMode.light
                          ? Iconsax.sun_15
                          : Iconsax.moon5,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    l10n.settingsTheme,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsThemeDesc,
                    style: TextStyle(fontSize: 12, color: context.textHint),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 72, right: 16, bottom: 12),
                  child: Row(
                    children: [
                      _buildThemeChip(
                        context,
                        ref,
                        label: l10n.settingsThemeLight,
                        icon: Iconsax.sun_15,
                        mode: AppThemeMode.light,
                        isSelected: currentTheme == AppThemeMode.light,
                      ),
                      const SizedBox(width: 8),
                      _buildThemeChip(
                        context,
                        ref,
                        label: l10n.settingsThemeDark,
                        icon: Iconsax.moon5,
                        mode: AppThemeMode.dark,
                        isSelected: currentTheme == AppThemeMode.dark,
                      ),
                      const SizedBox(width: 8),
                      _buildThemeChip(
                        context,
                        ref,
                        label: l10n.settingsThemeBlack,
                        icon: Iconsax.mobile,
                        mode: AppThemeMode.black,
                        isSelected: currentTheme == AppThemeMode.black,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, indent: 72, color: context.borderColor),
                // Language
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.language_square,
                      color: AppColors.info,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    l10n.settingsLanguage,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsLanguageLabel,
                    style: TextStyle(fontSize: 12, color: context.textHint),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.subtleBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentLocale,
                        isDense: true,
                        borderRadius: BorderRadius.circular(12),
                        dropdownColor: context.cardBg,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                        icon: Icon(Iconsax.arrow_down_1,
                            size: 16, color: context.iconSubtle),
                        items: [
                          DropdownMenuItem(
                            value: 'fr',
                            child: Text(l10n.settingsLanguageFrench),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(l10n.settingsLanguageEnglish),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(localeProvider.notifier).setLocale(value);
                          }
                        },
                      ),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About section
          _buildSectionHeader(context, l10n.settingsAbout),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Iconsax.info_circle,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              title: Text(
                l10n.settingsVersion,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimary,
                ),
              ),
              trailing: Text(
                '1.0.0',
                style: TextStyle(fontSize: 13, color: context.textHint),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required AppThemeMode mode,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(themeModeProvider.notifier).setTheme(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : context.subtleBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : context.borderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : context.iconSubtle,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : context.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: context.textHint,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
