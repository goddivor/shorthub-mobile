// lib/widgets/cards/user_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../config/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../config/theme/theme_extensions.dart';
import '../../core/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onBlock;
  final VoidCallback? onUnblock;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onBlock,
    this.onUnblock,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isBlocked = user.status == 'BLOCKED';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: _getRoleColor(user.role ?? '').withValues(alpha:0.1),
                      backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                          ? NetworkImage(user.profileImage!)
                          : null,
                      child: user.profileImage == null || user.profileImage!.isEmpty
                          ? Text(
                              user.username.isNotEmpty
                                  ? user.username[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getRoleColor(user.role ?? ''),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  user.username,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isBlocked ? context.textHint : context.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isBlocked)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha:0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.lock,
                                        size: 12,
                                        color: AppColors.error,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Bloqué',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (user.email != null && user.email!.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Iconsax.sms,
                                  size: 14,
                                  color: context.textHint,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    user.email!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: context.textTertiary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(user.role ?? '').withValues(alpha:0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getRoleIcon(user.role ?? ''),
                                      size: 12,
                                      color: _getRoleColor(user.role ?? ''),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getRoleLabel(user.role ?? ''),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _getRoleColor(user.role ?? ''),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (user.lastLogin != null)
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        PhosphorIcons.clock(PhosphorIconsStyle.regular),
                                        size: 12,
                                        color: context.textHint,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          _getLastLoginText(user.lastLogin!),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: context.textHint,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Actions Menu
                    PopupMenuButton<String>(
                      icon: Icon(
                        PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
                        color: context.textTertiary,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'block',
                          child: Row(
                            children: [
                              Icon(
                                isBlocked ? Iconsax.unlock : Iconsax.lock,
                                size: 18,
                                color: isBlocked ? AppColors.success : AppColors.warning,
                              ),
                              const SizedBox(width: 8),
                              Text(isBlocked ? AppLocalizations.of(context)!.usersUnblockButton : AppLocalizations.of(context)!.usersBlockButton),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'details',
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.user,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.userViewProfile),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.trash,
                                size: 18,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.usersDeleteButton,
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'block':
                            if (isBlocked) {
                              onUnblock?.call();
                            } else {
                              onBlock?.call();
                            }
                            break;
                          case 'details':
                            onTap?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  Color _getRoleColor(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return AppColors.error;
      case 'VIDEASTE':
        return AppColors.primary;
      case 'ASSISTANT':
        return AppColors.secondary;
      default:
        return AppColors.gray500;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return Iconsax.shield_tick;
      case 'VIDEASTE':
        return Iconsax.video;
      case 'ASSISTANT':
        return Iconsax.clipboard_tick;
      default:
        return Iconsax.user;
    }
  }

  String _getLastLoginText(DateTime lastLogin) {
    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 30) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return 'Il y a ${(difference.inDays / 30).floor()} mois';
    }
  }
}
