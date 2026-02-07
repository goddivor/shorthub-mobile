// lib/widgets/common/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/user.dart';
import '../../providers/auth_provider.dart';

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
                _buildNavigationSection(context),
                const Divider(height: 1),
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
            user.email ?? 'Aucun email',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getRoleLabel(user.role ?? ''),
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

  Widget _buildNavigationSection(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'NAVIGATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.gray500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),

        // Dashboard items based on role
        ..._buildRoleBasedNavigation(context, currentRoute),
      ],
    );
  }

  List<Widget> _buildRoleBasedNavigation(BuildContext context, String? currentRoute) {
    switch (user.role?.toUpperCase() ?? '') {
      case 'ADMIN':
        return [
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
            title: 'Tableau de bord',
            route: AppRoutes.adminDashboard,
            isActive: currentRoute == AppRoutes.adminDashboard,
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
            title: 'Vidéos',
            route: AppRoutes.adminDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to videos tab
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.users(PhosphorIconsStyle.fill),
            title: 'Équipe',
            route: AppRoutes.adminDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to users tab
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.chartLine(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.chartLine(PhosphorIconsStyle.fill),
            title: 'Statistiques',
            route: AppRoutes.adminDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to stats
            },
          ),
        ];

      case 'VIDEASTE':
        return [
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
            title: 'Tableau de bord',
            route: AppRoutes.videasteDashboard,
            isActive: currentRoute == AppRoutes.videasteDashboard,
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
            title: 'Vidéos assignées',
            route: AppRoutes.videasteDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to assigned videos tab
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.fill),
            title: 'En cours',
            route: AppRoutes.videasteDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to in progress tab
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
            title: 'Terminées',
            route: AppRoutes.videasteDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to completed tab
            },
          ),
        ];

      case 'ASSISTANT':
        return [
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
            title: 'Tableau de bord',
            route: AppRoutes.assistantDashboard,
            isActive: currentRoute == AppRoutes.assistantDashboard,
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.clipboardText(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.clipboardText(PhosphorIconsStyle.fill),
            title: 'À valider',
            route: AppRoutes.assistantDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to pending validation tab
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
            title: 'Validées',
            route: AppRoutes.assistantDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to validated tab
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: PhosphorIcons.xCircle(PhosphorIconsStyle.regular),
            activeIcon: PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
            title: 'Rejetées',
            route: AppRoutes.assistantDashboard,
            isActive: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to rejected tab
            },
          ),
        ];

      default:
        return [];
    }
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PARAMÈTRES',
              style: TextStyle(
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
          title: 'Mon profil',
          route: AppRoutes.profile,
          isActive: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.profile);
          },
        ),

        // Settings
        _buildDrawerItem(
          context: context,
          icon: Iconsax.setting_2,
          activeIcon: Iconsax.setting_2,
          title: 'Paramètres',
          route: '/settings', // TODO: Add route
          isActive: false,
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Page paramètres à venir'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),

        const Divider(height: 1),

        // Logout
        _buildDrawerItem(
          context: context,
          icon: Iconsax.logout,
          activeIcon: Iconsax.logout,
          title: 'Déconnexion',
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
        ? AppColors.primary.withOpacity(0.1)
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

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
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
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return 'Administrateur';
      case 'VIDEASTE':
        return 'Vidéaste';
      case 'ASSISTANT':
        return 'Assistant';
      default:
        return role;
    }
  }
}
