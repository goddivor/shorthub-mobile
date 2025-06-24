import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shorthub/widgets/common_widgets.dart' as custom_widgets;

import '../providers/app_providers.dart';
import '../models/channel_models.dart';
import '../widgets/channel_form_widget.dart';
import '../theme/app_theme.dart';

/// Main overlay screen that appears when YouTube content is shared
class SharingOverlayScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SharingOverlayScreen> createState() =>
      _SharingOverlayScreenState();
}

class _SharingOverlayScreenState extends ConsumerState<SharingOverlayScreen>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _sheetController;
  late Animation<double> _overlayAnimation;
  late Animation<Offset> _sheetAnimation;

  @override
  void initState() {
    super.initState();

    // Set up animations
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sheetController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _overlayAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOut,
    ));

    _sheetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _overlayController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _sheetController.forward();
    });
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _closeOverlay() async {
    await _sheetController.reverse();
    await _overlayController.reverse();

    // Clear shared URL and return to home
    ref.read(sharedUrlProvider.notifier).clear();
    ref.read(shareIntentProvider.notifier).clear();
    ref.read(channelFormProvider.notifier).reset();
    ref.read(channelSaveProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final shareIntentData = ref.watch(shareIntentProvider);
    final saveState = ref.watch(channelSaveProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _overlayAnimation,
        builder: (context, child) {
          return Container(
            color: AppColors.overlayBackground.withValues(
              alpha: _overlayAnimation.value * 0.8,
            ),
            child: GestureDetector(
              onTap: _closeOverlay,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: SlideTransition(
                  position: _sheetAnimation,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {}, // Prevent tap from closing overlay
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.85,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Handle bar
                            Container(
                              width: 40.w,
                              height: 4.h,
                              margin: EdgeInsets.only(top: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.bottomSheetHandle,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),

                            // Header
                            Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.youtubeRed,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add to ShortHub',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        Text(
                                          'Save this YouTube channel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _closeOverlay,
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 24.sp,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Flexible(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: _buildContent(
                                    context, shareIntentData, saveState),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ShareIntentData? shareIntentData,
    AsyncValue<void> saveState,
  ) {
    // Handle save success
    if (saveState.hasValue && shareIntentData != null) {
      return custom_widgets.SuccessWidget(
        onClose: _closeOverlay,
        channelName: shareIntentData.channelData?.username ?? 'Unknown',
      );
    }

    // Handle save error
    if (saveState.hasError) {
      return custom_widgets.ErrorWidget(
        error: saveState.error.toString(),
        onRetry: () {
          ref.read(channelSaveProvider.notifier).reset();
        },
        onClose: _closeOverlay,
      );
    }

    // Handle saving state
    if (saveState.isLoading) {
      return custom_widgets.LoadingWidget(
        message: 'Saving channel to ShortHub...',
      );
    }

    // Handle share data loading
    if (shareIntentData == null) {
      return custom_widgets.LoadingWidget(
        message: 'Processing shared link...',
      );
    }

    // Handle share data error
    if (shareIntentData.error != null) {
      return custom_widgets.ErrorWidget(
        error: shareIntentData.error!,
        onRetry: () {
          final url = ref.read(sharedUrlProvider);
          if (url != null) {
            ref.read(shareIntentProvider.notifier).processSharedUrl(url);
          }
        },
        onClose: _closeOverlay,
      );
    }

    // Handle share data loading
    if (shareIntentData.isLoading) {
      return custom_widgets.LoadingWidget(
        message: 'Extracting channel information...',
      );
    }

    // Handle no channel data
    if (shareIntentData.channelData == null) {
      return custom_widgets.ErrorWidget(
        error: 'Could not extract channel information from this link',
        onClose: _closeOverlay,
      );
    }

    // Show the form
    return ChannelFormWidget(
      shareIntentData: shareIntentData,
      onSave: (formData) {
        // Trigger save
        ref.read(channelSaveProvider.notifier).saveChannel(
              shareData: shareIntentData,
              formData: formData,
            );
      },
      onCancel: _closeOverlay,
    );
  }
}
