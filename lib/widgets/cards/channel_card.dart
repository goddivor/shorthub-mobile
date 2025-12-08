// lib/widgets/cards/channel_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../config/theme/app_colors.dart';

class ChannelCard extends StatelessWidget {
  final String id;
  final String channelId;
  final String channelName;
  final String? profileImageUrl;
  final String? contentType;
  final int? totalVideos;
  final int? subscriberCount;
  final bool isSourceChannel;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ChannelCard({
    super.key,
    required this.id,
    required this.channelId,
    required this.channelName,
    this.profileImageUrl,
    this.contentType,
    this.totalVideos,
    this.subscriberCount,
    this.isSourceChannel = true,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            child: Row(
              children: [
                // Channel Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(28),
                    image: profileImageUrl != null && profileImageUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(profileImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: profileImageUrl == null || profileImageUrl!.isEmpty
                      ? Icon(
                          PhosphorIcons.youtubeLogo(PhosphorIconsStyle.fill),
                          color: AppColors.error,
                          size: 32,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // Channel Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Channel Name
                      Text(
                        channelName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Channel ID
                      Row(
                        children: [
                          Icon(
                            Iconsax.link,
                            size: 12,
                            color: AppColors.gray500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              channelId,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Stats
                      Row(
                        children: [
                          // Content Type
                          if (contentType != null && contentType!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getContentTypeColor(contentType!).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.category,
                                    size: 12,
                                    color: _getContentTypeColor(contentType!),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getContentTypeLabel(contentType!),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _getContentTypeColor(contentType!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 8),

                          // Total Videos
                          if (totalVideos != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.video,
                                  size: 12,
                                  color: AppColors.gray500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$totalVideos',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                          // Subscribers (for admin channels)
                          if (subscriberCount != null) ...[
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.people,
                                  size: 12,
                                  color: AppColors.gray500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatSubscriberCount(subscriberCount!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions Menu
                PopupMenuButton<String>(
                  icon: Icon(
                    PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
                    color: AppColors.gray600,
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.eye,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text('Voir la chaîne'),
                        ],
                      ),
                    ),
                    if (isSourceChannel)
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.edit,
                              size: 18,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 8),
                            const Text('Modifier'),
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
                            'Supprimer',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        onTap?.call();
                        break;
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getContentTypeLabel(String contentType) {
    switch (contentType) {
      case 'VA_SANS_EDIT':
        return 'VA Sans Edit';
      case 'VA_AVEC_EDIT':
        return 'VA Avec Edit';
      case 'VF_SANS_EDIT':
        return 'VF Sans Edit';
      case 'VF_AVEC_EDIT':
        return 'VF Avec Edit';
      case 'VO_SANS_EDIT':
        return 'VO Sans Edit';
      case 'VO_AVEC_EDIT':
        return 'VO Avec Edit';
      default:
        return contentType;
    }
  }

  Color _getContentTypeColor(String contentType) {
    if (contentType.startsWith('VA')) {
      return AppColors.primary;
    } else if (contentType.startsWith('VF')) {
      return AppColors.success;
    } else if (contentType.startsWith('VO')) {
      return AppColors.secondary;
    }
    return AppColors.gray500;
  }

  String _formatSubscriberCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
