// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../providers/app_providers.dart';
import '../screens/channels_list_screen.dart';
import '../screens/add_channel_screen.dart';
import '../theme/app_theme.dart';

/// Main screen with bottom tab navigation
class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(mainTabProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: AppColors.youtubeRed,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.youtubeRed,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'ShortHub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Refresh current tab data
              if (currentTab == 0) {
                ref.invalidate(channelsProvider);
              }
            },
            icon: Icon(
              Iconsax.refresh,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentTab,
        children: [
          ChannelsListScreen(),
          AddChannelScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabItem(
                  context: context,
                  ref: ref,
                  index: 0,
                  icon: Iconsax.video_square,
                  activeIcon: Iconsax.video_square5,
                  label: 'Channels',
                  isActive: currentTab == 0,
                ),
                _buildTabItem(
                  context: context,
                  ref: ref,
                  index: 1,
                  icon: Iconsax.add_circle,
                  activeIcon: Iconsax.add_circle5,
                  label: 'Add Channel',
                  isActive: currentTab == 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(mainTabProvider.notifier).state = index;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.youtubeRed.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.youtubeRed : Colors.grey[600],
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? AppColors.youtubeRed : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}