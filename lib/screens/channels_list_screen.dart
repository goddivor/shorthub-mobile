import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/app_providers.dart';
import '../models/channel_models.dart';
import '../services/youtube_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

/// Screen displaying the list of saved channels
class ChannelsListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return Container(
      color: Colors.grey[50],
      child: channelsAsync.when(
        data: (channels) => _buildChannelsList(context, ref, channels),
        loading: () => LoadingWidget(
          message: 'Loading your channels...',
        ),
        error: (error, stackTrace) => _buildError(context, ref, error.toString()),
      ),
    );
  }

  Widget _buildChannelsList(BuildContext context, WidgetRef ref, List<Channel> channels) {
    if (channels.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return Column(
      children: [
        // Header with count
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          color: Colors.white,
          child: Row(
            children: [
              Icon(
                Iconsax.video_square,
                color: AppColors.youtubeRed,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '${channels.length} Channel${channels.length > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                'Total: ${_getTotalSubscribers(channels)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.youtubeRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Channels list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: channels.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return ChannelCardWidget(
                channel: channels[index],
                onDelete: () => _deleteChannel(context, ref, channels[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.youtubeRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Iconsax.video_square,
                color: AppColors.youtubeRed,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No Channels Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Start by adding your first YouTube channel using the form or by sharing from the YouTube app.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(mainTabProvider.notifier).state = 1;
                },
                icon: Icon(
                  Iconsax.add_circle,
                  size: 20.sp,
                ),
                label: Text(
                  'Add Your First Channel',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.youtubeRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton.icon(
              onPressed: () async {
                const url = 'https://youtube.com';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              icon: Icon(
                Iconsax.export_1,
                size: 16.sp,
              ),
              label: Text('Open YouTube'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.youtubeRed,
                side: BorderSide(color: AppColors.youtubeRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.close_circle,
              color: AppColors.error,
              size: 64.sp,
            ),
            SizedBox(height: 24.h),
            Text(
              'Failed to Load Channels',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(channelsProvider);
              },
              icon: Icon(Iconsax.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.youtubeRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTotalSubscribers(List<Channel> channels) {
    final total = channels.fold(0, (sum, channel) => sum + channel.subscriberCount);
    return YouTubeService.formatSubscriberCount(total);
  }

  void _deleteChannel(BuildContext context, WidgetRef ref, Channel channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Channel'),
        content: Text('Are you sure you want to delete "${channel.username}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                if (channel.id != null) {
                  await ref.read(deleteChannelProvider(channel.id!).future);
                  ref.invalidate(channelsProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Channel deleted successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete channel'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}