// lib/widgets/common/custom_drawer.dart
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/banner_provider.dart';
import '../../l10n/app_localizations.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  final User user;

  const CustomDrawer({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: context.isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.white,
      child: Column(
        children: [
          // Header with banner + centered avatar
          _buildDrawerHeader(context),

          // Menu items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                children: [
                  // Profile
                  _buildMenuItem(
                    context: context,
                    icon: Iconsax.user,
                    title: l10n.drawerProfile,
                    iconBgColor: AppColors.primary,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),
                  const SizedBox(height: 4),

                  // Settings
                  _buildMenuItem(
                    context: context,
                    icon: Iconsax.setting_2,
                    title: l10n.drawerSettings,
                    iconBgColor: AppColors.secondary,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.settings);
                    },
                  ),

                  const Spacer(),

                  // Logout
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    context: context,
                    icon: Iconsax.logout,
                    title: l10n.drawerLogout,
                    iconBgColor: AppColors.error,
                    isDestructive: true,
                    onTap: () => _showLogoutDialog(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final user = widget.user;
    final bannerPath = ref.watch(bannerProvider);

    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          // Banner background (custom image or gradient fallback)
          Positioned.fill(
            bottom: 40,
            child: GestureDetector(
              onTap: () => _showBannerOptions(context),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (bannerPath != null && File(bannerPath).existsSync())
                    ClipRect(
                      child: Image.file(
                        File(bannerPath),
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.85),
                            AppColors.secondary.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _BannerPatternPainter(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),

                  // Dark overlay for text readability (when image is set)
                  if (bannerPath != null)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),

                  // Camera icon button
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.camera,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Username + role on banner
          Positioned(
            left: 20,
            bottom: 56,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getRoleLabel(user.role ?? '', context),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Centered avatar with spinning ring (more spacing)
          Positioned(
            top: 46,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 92,
                height: 92,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Spinning gradient ring
                    AnimatedBuilder(
                      animation: _ringController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _ringController.value * 2 * math.pi,
                          child: Container(
                            width: 92,
                            height: 92,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                  AppColors.success,
                                  AppColors.warning,
                                  AppColors.primary,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Inner circle (gap between ring and avatar)
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.isDark
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Colors.white,
                      ),
                    ),

                    // Actual avatar
                    CircleAvatar(
                      radius: 35,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.15),
                      backgroundImage: user.profileImage != null &&
                              user.profileImage!.isNotEmpty
                          ? NetworkImage(user.profileImage!)
                          : null,
                      child: user.profileImage == null ||
                              user.profileImage!.isEmpty
                          ? Text(
                              user.username.isNotEmpty
                                  ? user.username[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBannerOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasBanner = ref.read(bannerProvider) != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Iconsax.gallery, color: AppColors.primary),
              title: Text(
                l10n.drawerChangeBanner,
                style: TextStyle(color: context.textPrimary),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                await ref.read(bannerProvider.notifier).pickBannerImage();
              },
            ),
            if (hasBanner)
              ListTile(
                leading: Icon(Iconsax.trash, color: AppColors.error),
                title: Text(
                  l10n.drawerRemoveBanner,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(bannerProvider.notifier).removeBannerImage();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconBgColor,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final textColor = isDestructive ? AppColors.error : context.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconBgColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (!isDestructive)
                Icon(Iconsax.arrow_right_3,
                    size: 18, color: context.iconSubtle),
            ],
          ),
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

/// Custom painter for subtle geometric pattern on the banner
class _BannerPatternPainter extends CustomPainter {
  final Color color;

  _BannerPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      60,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.7),
      40,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.85),
      30,
      paint,
    );

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 8; i++) {
      final x = (size.width * 0.15) + (i * size.width * 0.1);
      final y = size.height * 0.15 + (i % 3) * 20;
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
