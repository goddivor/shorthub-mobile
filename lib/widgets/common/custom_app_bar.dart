// lib/widgets/common/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/user.dart';
import '../../providers/notifications_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final User user;
  final String? title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const CustomAppBar({
    super.key,
    required this.user,
    this.title,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadAsync = ref.watch(unreadNotificationsCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    // Listen to real-time notification subscription (auto-refreshes unread count)
    ref.listen(notificationSubscriptionProvider, (_, __) {});

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      title: Text(
        title ?? 'ShortHub',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.gray900,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        // Notification Button
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Iconsax.notification,
                color: AppColors.gray700,
                size: 24,
              ),
              onPressed: onNotificationTap ?? () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),

        // Avatar
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onAvatarTap ?? () {
              Scaffold.of(context).openEndDrawer();
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                  ? NetworkImage(user.profileImage!)
                  : null,
              child: user.profileImage == null || user.profileImage!.isEmpty
                  ? Text(
                      user.username.isNotEmpty
                          ? user.username[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
