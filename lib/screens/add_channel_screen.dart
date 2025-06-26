// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../providers/app_providers.dart';
import '../models/channel_models.dart';
import '../services/youtube_service.dart';
import '../theme/app_theme.dart';
// import '../widgets/common_widgets.dart';

/// Screen for adding new channels
class AddChannelScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddChannelScreen> createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends ConsumerState<AddChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  
  bool _isExtracting = false;
  YouTubeChannelData? _channelData;
  TagType? _selectedTag;
  ChannelType? _selectedType;
  ContentCategory? _selectedCategory;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    // Check if there's a shared URL when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sharedUrl = ref.read(sharedUrlProvider);
      if (sharedUrl != null) {
        _urlController.text = sharedUrl;
        _extractChannelData();
        // Clear the shared URL after using it
        ref.read(sharedUrlProvider.notifier).clear();
      }
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _extractChannelData() async {
    if (_urlController.text.trim().isEmpty) return;

    setState(() {
      _isExtracting = true;
      _errorMessage = null;
      _channelData = null;
    });

    try {
      final youtubeService = ref.read(youtubeServiceProvider);
      final channelData = await youtubeService.extractChannelData(_urlController.text.trim());
      
      setState(() {
        _channelData = channelData;
        _isExtracting = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isExtracting = false;
      });
    }
  }

  Future<void> _saveChannel() async {
    if (!_formKey.currentState!.validate() || _channelData == null) return;

    final channel = Channel(
      youtubeUrl: _urlController.text.trim(),
      username: _channelData!.username,
      subscriberCount: _channelData!.subscriberCount,
      tag: _selectedTag!,
      type: _selectedType!,
      domain: _selectedType == ChannelType.only ? _selectedCategory?.value : null,
    );

    try {
      await ref.read(saveChannelProvider(channel).future);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Channel added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Reset form
      _resetForm();
      
      // Refresh channels list and go back to list tab
      ref.invalidate(channelsProvider);
      ref.read(mainTabProvider.notifier).state = 0;
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save channel: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _resetForm() {
    _urlController.clear();
    setState(() {
      _channelData = null;
      _selectedTag = null;
      _selectedType = null;
      _selectedCategory = null;
      _errorMessage = null;
    });
  }

  bool get _isFormValid {
    return _channelData != null && 
           _selectedTag != null && 
           _selectedType != null &&
           (_selectedType != ChannelType.only || _selectedCategory != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 24.h),
              
              // URL Input Section
              _buildUrlSection(),
              SizedBox(height: 24.h),
              
              // Channel Data Section
              if (_channelData != null) ...[
                _buildChannelDataSection(),
                SizedBox(height: 24.h),
              ],
              
              // Error Section
              if (_errorMessage != null) ...[
                _buildErrorSection(),
                SizedBox(height: 24.h),
              ],
              
              // Form Fields Section
              if (_channelData != null) ...[
                _buildFormFieldsSection(),
                SizedBox(height: 32.h),
              ],
              
              // Action Buttons
              if (_channelData != null) _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.youtubeRed,
            AppColors.youtubeRedLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.add_circle,
            color: Colors.white,
            size: 40.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'Add New Channel',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Enter a YouTube channel URL to extract information and add it to your collection',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUrlSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YouTube Channel URL',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Paste the YouTube channel URL here',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'https://youtube.com/@channel',
                    prefixIcon: Icon(
                      Iconsax.link,
                      color: AppColors.youtubeRed,
                    ),
                    suffixIcon: _urlController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _urlController.clear();
                              setState(() {
                                _channelData = null;
                                _errorMessage = null;
                              });
                            },
                            icon: Icon(Iconsax.close_circle),
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a YouTube URL';
                    }
                    if (!YouTubeService.isValidYouTubeUrl(value.trim())) {
                      return 'Please enter a valid YouTube URL';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: ElevatedButton(
                  onPressed: _isExtracting ? null : _extractChannelData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.youtubeRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _isExtracting
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          Iconsax.search_normal_1,
                          color: AppColors.textOnDark,
                          size: 20.sp,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelDataSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.tick_circle,
                color: AppColors.success,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Channel Found!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Channel Avatar Placeholder
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.youtubeRed,
                  borderRadius: BorderRadius.circular(8.r),
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
                      _channelData!.username,
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
                          '${YouTubeService.formatSubscriberCount(_channelData!.subscriberCount)} subscribers',
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
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.close_circle,
                color: AppColors.error,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Error',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _extractChannelData,
              icon: Icon(Iconsax.refresh),
              label: Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFieldsSection() {
    return Column(
      children: [
        // Tag Selection
        _buildTagSection(),
        SizedBox(height: 24.h),
        
        // Type Selection
        _buildTypeSection(),
        
        // Category Selection (only for "Only" type)
        if (_selectedType == ChannelType.only) ...[
          SizedBox(height: 24.h),
          _buildCategorySection(),
        ],
      ],
    );
  }

  Widget _buildTagSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.language_square,
                color: AppColors.youtubeRed,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Language Tag *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Select the primary language of this channel\'s content',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: TagType.values.map((tag) {
              final isSelected = _selectedTag == tag;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTag = tag;
                  });
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
        ],
      ),
    );
  }

  Widget _buildTypeSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.category,
                color: AppColors.youtubeRed,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Content Type *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Does this channel cover mixed topics or specialize in one area?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: ChannelType.values.map((type) {
              final isSelected = _selectedType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      if (type == ChannelType.mix) {
                        _selectedCategory = null;
                      }
                    });
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
                          type == ChannelType.mix ? Iconsax.element_4 : Iconsax.category_2,
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
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.typeOnly.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.typeOnly.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.tag,
                color: AppColors.typeOnly,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Specialization Category *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'What is the main focus of this specialized channel?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: ContentCategory.values.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
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
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Save Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: _isFormValid ? _saveChannel : null,
            icon: Icon(
              Iconsax.add_circle,
              size: 20.sp,
            ),
            label: Text(
              'Add to ShortHub',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.youtubeRed,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Reset Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: _resetForm,
            icon: Icon(
              Iconsax.refresh_2,
              size: 20.sp,
            ),
            label: Text(
              'Reset Form',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}