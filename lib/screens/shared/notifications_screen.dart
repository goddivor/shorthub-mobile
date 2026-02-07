// lib/screens/shared/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/notification.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../l10n/app_localizations.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.notificationsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationsServiceProvider).markAllAsRead();
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadNotificationsCountProvider);
            },
            child: Text(AppLocalizations.of(context)!.notificationsMarkAllRead, style: TextStyle(color: AppColors.primary, fontSize: 13)),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.notification, size: 64, color: AppColors.gray300),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.notificationsEmpty, style: TextStyle(fontSize: 16, color: context.textTertiary)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadNotificationsCountProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return _NotificationCard(
                  notification: notif,
                  onTap: () async {
                    if (!notif.read) {
                      await ref.read(notificationsServiceProvider).markAsRead(notif.id);
                      ref.invalidate(notificationsProvider);
                      ref.invalidate(unreadNotificationsCountProvider);
                    }
                    if (notif.shortId != null && context.mounted) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.shortDetails,
                        arguments: notif.shortId,
                      );
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => LoadingIndicator(message: AppLocalizations.of(context)!.loadingNotifications),
        error: (error, _) => ErrorDisplay(
          message: AppLocalizations.of(context)!.errorLoadingNotifications,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  IconData _getIcon() {
    switch (notification.type) {
      case 'VIDEO_ASSIGNED':
        return Iconsax.user_tick;
      case 'DEADLINE_REMINDER':
        return Iconsax.timer_1;
      case 'VIDEO_COMPLETED':
        return Iconsax.tick_circle;
      case 'VIDEO_VALIDATED':
        return Iconsax.shield_tick;
      case 'VIDEO_REJECTED':
        return Iconsax.close_circle;
      case 'ACCOUNT_BLOCKED':
        return Iconsax.lock;
      case 'ACCOUNT_UNBLOCKED':
        return Iconsax.unlock;
      default:
        return Iconsax.notification;
    }
  }

  Color _getColor() {
    switch (notification.type) {
      case 'VIDEO_ASSIGNED':
        return AppColors.primary;
      case 'DEADLINE_REMINDER':
        return AppColors.warning;
      case 'VIDEO_COMPLETED':
        return AppColors.success;
      case 'VIDEO_VALIDATED':
        return AppColors.statusValidated;
      case 'VIDEO_REJECTED':
        return AppColors.error;
      case 'ACCOUNT_BLOCKED':
        return AppColors.error;
      case 'ACCOUNT_UNBLOCKED':
        return AppColors.success;
      default:
        return AppColors.gray500;
    }
  }

  String _formatTimeAgo(DateTime date, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.read ? context.cardBg : color.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: notification.read
              ? null
              : Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        notification.typeLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: notification.read ? FontWeight.w500 : FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTimeAgo(notification.createdAt, context),
                        style: TextStyle(fontSize: 11, color: context.textHint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                      fontWeight: notification.read ? FontWeight.normal : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!notification.read) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
