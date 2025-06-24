import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/channel_models.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../services/youtube_service.dart';

/// Form widget for adding channel details in the sharing overlay
class ChannelFormWidget extends ConsumerWidget {
  final ShareIntentData shareIntentData;
  final Function(ChannelFormData) onSave;
  final VoidCallback onCancel;

  const ChannelFormWidget({
    super.key,
    required this.shareIntentData,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(channelFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Channel Info Card
        _buildChannelInfoCard(context),
        SizedBox(height: 24.h),
        
        // Form Fields
        _buildFormFields(context, ref, formData),
        SizedBox(height: 32.h),
        
        // Action Buttons
        _buildActionButtons(context, formData),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildChannelInfoCard(BuildContext context) {
    final channelData = shareIntentData.channelData!;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.youtubeRed.withOpacity(0.1),
            AppColors.youtubeRedLight.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.youtubeRed.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Channel Avatar
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.youtubeRed,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: channelData.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: CachedNetworkImage(
                          imageUrl: channelData.thumbnailUrl!,
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
                      channelData.username,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: 14.sp,
                          color: AppColors.youtubeRed,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${YouTubeService.formatSubscriberCount(channelData.subscriberCount)} subscribers',
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
              
              // YouTube Icon
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.youtubeRed,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ],
          ),
          
          // URL Preview
          if (shareIntentData.originalUrl != shareIntentData.extractedChannelUrl)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  shareIntentData.extractedChannelUrl ?? shareIntentData.originalUrl,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context, WidgetRef ref, ChannelFormData formData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag Selection
        Text(
          'Language Tag *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        Text(
          'Select the primary language of this channel\'s content',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: TagType.values.map((tag) {
            final isSelected = formData.selectedTag == tag;
            return GestureDetector(
              onTap: () {
                ref.read(channelFormProvider.notifier).setTag(tag);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? tag.backgroundColor : Colors.grey[100],
                  border: Border.all(
                    color: isSelected ? tag.color : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  tag.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? tag.color : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        SizedBox(height: 24.h),
        
        // Type Selection
        Text(
          'Content Type *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        Text(
          'Does this channel cover mixed topics or specialize in one area?',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 12.h),
        Row(
          children: ChannelType.values.map((type) {
            final isSelected = formData.selectedType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(channelFormProvider.notifier).setType(type);
                },
                child: Container(
                  margin: EdgeInsets.only(right: type == ChannelType.mix ? 8.w : 0),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isSelected ? type.backgroundColor : Colors.grey[100],
                    border: Border.all(
                      color: isSelected ? type.color : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        type == ChannelType.mix 
                            ? Icons.dashboard_rounded 
                            : Icons.category_rounded,
                        color: isSelected ? type.color : Colors.grey[600],
                        size: 24.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        type.value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? type.color : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        type == ChannelType.mix ? 'Various topics' : 'Specialized',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        // Category Selection (only for "Only" type)
        if (formData.selectedType == ChannelType.only) ...[
          SizedBox(height: 24.h),
          Text(
            'Specialization Category *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            'What is the main focus of this specialized channel?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: ContentCategory.values.map((category) {
              final isSelected = formData.selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  ref.read(channelFormProvider.notifier).setCategory(category);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.typeOnly.withOpacity(0.1) : Colors.grey[100],
                    border: Border.all(
                      color: isSelected ? AppColors.typeOnly : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    category.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? AppColors.typeOnly : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ChannelFormData formData) {
    return Column(
      children: [
        // Save Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: formData.isValid ? () => onSave(formData) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.youtubeRed,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.save_rounded,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Add to ShortHub',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Cancel Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}