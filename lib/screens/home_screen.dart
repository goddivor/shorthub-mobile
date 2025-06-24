import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shorthub/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/app_providers.dart';
import '../models/channel_models.dart';
import '../theme/app_theme.dart';

/// Home screen shown when app is opened normally (not via sharing)
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appInitState = ref.watch(appInitProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: appInitState.when(
        data: (isInitialized) {
          if (!isInitialized) {
            return _buildConnectionError();
          }
          return _buildHomeContent();
        },
        loading: () => LoadingWidget(
          message: 'Initializing ShortHub...',
        ),
        error: (error, stackTrace) => _buildConnectionError(),
      ),
    );
  }

  Widget _buildConnectionError() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Connection Error',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Could not connect to ShortHub services. Please check your internet connection and try again.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(appInitProvider);
              },
              icon: Icon(Icons.refresh_rounded),
              label: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final statsAsync = ref.watch(statsProvider);
    final channelsAsync = ref.watch(channelsProvider);

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120.h,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.youtubeRed,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.youtubeRed,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'ShortHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: () {
                ref.invalidate(statsProvider);
                ref.invalidate(channelsProvider);
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Stats Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 12.h),
                statsAsync.when(
                  data: (stats) => _buildStatsGrid(stats),
                  loading: () => _buildStatsLoading(),
                  error: (error, stackTrace) => _buildStatsError(),
                ),
              ],
            ),
          ),
        ),

        // Channels Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Channels',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(channelsProvider);
                      },
                      child: Text('Refresh'),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),

        // Channels List
        channelsAsync.when(
          data: (channels) => _buildChannelsList(channels),
          loading: () => SliverToBoxAdapter(
            child: LoadingWidget(message: 'Loading channels...'),
          ),
          error: (error, stackTrace) => SliverToBoxAdapter(
            child: _buildChannelsError(),
          ),
        ),

        // Footer
        SliverToBoxAdapter(
          child: _buildFooter(),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(Map<String, int> stats) {
    return Row(
      children: [
        Expanded(
          child: StatsCardWidget(
            title: 'Channels',
            value: stats['total_channels']?.toString() ?? '0',
            icon: Icons.video_collection_rounded,
            color: AppColors.youtubeRed,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatsCardWidget(
            title: 'Shorts',
            value: stats['total_shorts']?.toString() ?? '0',
            icon: Icons.movie_rounded,
            color: AppColors.typeMix,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatsCardWidget(
            title: 'Validated',
            value: stats['validated_shorts']?.toString() ?? '0',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsLoading() {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 2 ? 12.w : 0),
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsError() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 24.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load statistics',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelsList(List<Channel> channels) {
    if (channels.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyChannels(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: ChannelCardWidget(channel: channels[index]),
          );
        },
        childCount: channels.length,
      ),
    );
  }

  Widget _buildEmptyChannels() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Icons.video_collection_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Channels Yet',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Share YouTube channels or videos from the YouTube app to add them to ShortHub.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          OutlinedButton.icon(
            onPressed: () async {
              const url = 'https://youtube.com';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            icon: Icon(Icons.open_in_new_rounded),
            label: Text('Open YouTube'),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelsError() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64.sp,
            color: AppColors.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Failed to Load Channels',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Could not load your saved channels. Please check your connection and try again.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(channelsProvider);
            },
            icon: Icon(Icons.refresh_rounded),
            label: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Divider(),
          SizedBox(height: 16.h),
          Text(
            'ShortHub Mobile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          Text(
            'Optimize your YouTube Shorts workflow',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 16.h),
          Text(
            'Share YouTube content from the YouTube app to add channels automatically.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
