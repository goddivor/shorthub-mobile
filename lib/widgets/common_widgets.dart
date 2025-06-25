import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/channel_models.dart';
import '../services/youtube_service.dart';
import '../theme/app_theme.dart';

/// Loading widget with animated YouTube logo
class LoadingWidget extends StatefulWidget {
  final String message;
  
  const LoadingWidget({
    super.key,
    required this.message,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_animation.value * 0.2),
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.youtubeRed,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.youtubeRed.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            widget.message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Enhanced Channel card widget for displaying channels in list
class ChannelCardWidget extends StatelessWidget {
  final Channel channel;
  final VoidCallback? onDelete;

  const ChannelCardWidget({
    super.key,
    required this.channel,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Channel Avatar
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.youtubeRed,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Iconsax.user,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Channel Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel.username,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Iconsax.people,
                            color: AppColors.youtubeRed,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${YouTubeService.formatSubscriberCount(channel.subscriberCount)} subscribers',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.youtubeRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Open Channel Button
                    IconButton(
                      onPressed: () async {
                        if (await canLaunchUrl(Uri.parse(channel.youtubeUrl))) {
                          await launchUrl(
                            Uri.parse(channel.youtubeUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: Icon(
                        Iconsax.export_1,
                        color: AppColors.youtubeRed,
                        size: 20.sp,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.youtubeRed.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    
                    if (onDelete != null) ...[
                      SizedBox(width: 8.w),
                      // Delete Button
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Iconsax.trash,
                          color: AppColors.error,
                          size: 20.sp,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.error.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Tags Row
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                // Language Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: channel.tag.backgroundColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: channel.tag.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.language_square,
                        color: channel.tag.color,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        channel.tag.value,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: channel.tag.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Type Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: channel.type.backgroundColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: channel.type.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        channel.type == ChannelType.mix ? Iconsax.element_4 : Iconsax.category_2,
                        color: channel.type.color,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        channel.type.value,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: channel.type.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Domain Tag (if only type)
                if (channel.domain != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.tag,
                          color: Colors.purple[700],
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          channel.domain!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.purple[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // URL Preview
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.link,
                    color: Colors.grey[500],
                    size: 14.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      channel.youtubeUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Created date (if available)
            if (channel.createdAt != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar,
                    color: Colors.grey[400],
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Added ${_formatDate(channel.createdAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }
  }
}