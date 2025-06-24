import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

/// Error widget with retry functionality
class ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const ErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.error.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onRetry != null) ...[
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh_rounded),
                  label: Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.youtubeRed,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (onClose != null) SizedBox(width: 12.w),
              ],
              if (onClose != null)
                OutlinedButton(
                  onPressed: onClose,
                  child: Text('Close'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Success widget shown after saving
class SuccessWidget extends StatefulWidget {
  final VoidCallback onClose;
  final String channelName;

  const SuccessWidget({
    super.key,
    required this.onClose,
    required this.channelName,
  });

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _checkAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
    
    _controller.forward();
    
    // Auto close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onClose();
      }
    });
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
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(40.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Transform.scale(
                    scale: _checkAnimation.value,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Text(
            'Channel Added!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            '${widget.channelName} has been successfully added to your ShortHub collection.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: widget.onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats card widget for displaying statistics
class StatsCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Channel card widget for displaying channels in list
class ChannelCardWidget extends StatelessWidget {
  final Channel channel;

  const ChannelCardWidget({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Channel Avatar
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.youtubeRed,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: channel.thumbnailUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: channel.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.youtubeRed,
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.youtubeRed,
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
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
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${YouTubeService.formatSubscriberCount(channel.subscriberCount)} subscribers',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: channel.tag.backgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          channel.tag.value,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: channel.tag.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: channel.type.backgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          channel.type.value,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: channel.type.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (channel.domain != null) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            channel.domain!,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.purple[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Actions
            IconButton(
              onPressed: () {
                // Open channel URL
                // Could implement URL launcher here
              },
              icon: Icon(
                Icons.open_in_new_rounded,
                size: 20.sp,
                color: AppColors.youtubeRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}