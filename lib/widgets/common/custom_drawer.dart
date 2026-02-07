// lib/widgets/common/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class CustomDrawer extends ConsumerWidget {
  final User user;

  const CustomDrawer({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          // Header avec profil utilisateur
          _buildDrawerHeader(context),

          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSettingsSection(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null || user.profileImage!.isEmpty
                ? Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),

          // Nom d'utilisateur
          Text(
            user.username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            user.email ?? AppLocalizations.of(context)!.drawerNoEmail,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha:0.8),
            ),
          ),
          const SizedBox(height: 8),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getRoleLabel(user.role ?? '', context),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.navSettings,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.gray500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),

        // Profile
        _buildDrawerItem(
          context: context,
          icon: Iconsax.user,
          activeIcon: Iconsax.user,
          title: l10n.drawerProfile,
          route: AppRoutes.profile,
          isActive: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.profile);
          },
        ),

        // Dark mode toggle
        _buildDarkModeToggle(context, ref),

        // Language toggle
        _buildLanguageToggle(context, ref),

        const Divider(height: 1),

        // Logout
        _buildDrawerItem(
          context: context,
          icon: Iconsax.logout,
          activeIcon: Iconsax.logout,
          title: l10n.drawerLogout,
          route: '',
          isActive: false,
          isDestructive: true,
          onTap: () {
            _showLogoutDialog(context, ref);
          },
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String route,
    required bool isActive,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive
        ? AppColors.error
        : isActive
            ? AppColors.primary
            : AppColors.gray700;

    final backgroundColor = isActive
        ? AppColors.primary.withValues(alpha:0.1)
        : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isActive ? activeIcon : icon,
          color: color,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: color,
          ),
        ),
        onTap: onTap ??
            () {
              if (route.isNotEmpty && !isActive) {
                Navigator.pushReplacementNamed(context, route);
              } else {
                Navigator.pop(context);
              }
            },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(
          isDark ? Iconsax.moon : Iconsax.sun_1,
          color: AppColors.gray700,
          size: 24,
        ),
        title: Text(
          AppLocalizations.of(context)!.drawerDarkMode,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.gray700,
          ),
        ),
        value: isDark,
        activeTrackColor: AppColors.primary,
        onChanged: (_) {
          ref.read(themeModeProvider.notifier).toggle();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context, WidgetRef ref) {
    final isFrench = ref.watch(localeProvider).languageCode == 'fr';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(
          Iconsax.language_square,
          color: AppColors.gray700,
          size: 24,
        ),
        title: Text(
          AppLocalizations.of(context)!.drawerLanguage,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.gray700,
          ),
        ),
        subtitle: Text(
          isFrench ? 'Français' : 'English',
          style: TextStyle(fontSize: 12, color: AppColors.gray400),
        ),
        value: !isFrench,
        activeTrackColor: AppColors.primary,
        onChanged: (_) {
          ref.read(localeProvider.notifier).toggle();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.drawerLogout),
        content: Text(l10n.drawerLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ref.read(currentUserProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.drawerLogout),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return role;
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return l10n.roleAdmin;
      case 'VIDEASTE':
        return l10n.roleVideaste;
      case 'ASSISTANT':
        return l10n.roleAssistant;
      default:
        return role;
    }
  }
}
