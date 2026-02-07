// lib/screens/assistant/assistant_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../core/models/short.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_drawer.dart';
import '../../widgets/common/search_filter_bar.dart';
import '../../config/routes/app_routes.dart';
import '../../providers/navigation_provider.dart';
import '../../l10n/app_localizations.dart';

class AssistantDashboardScreen extends ConsumerStatefulWidget {
  const AssistantDashboardScreen({super.key});

  @override
  ConsumerState<AssistantDashboardScreen> createState() => _AssistantDashboardScreenState();
}

class _AssistantDashboardScreenState extends ConsumerState<AssistantDashboardScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)!.noUserConnected),
            ),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(user: user),
          endDrawer: CustomDrawer(user: user),
          body: Column(
            children: [
              _buildStatsHeader(),
              _buildTabBar(),
              SearchFilterBar(
                hintText: AppLocalizations.of(context)!.commonSearch,
                onSearchChanged: (v) => setState(() => _searchQuery = v),
              ),
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: LoadingIndicator(message: 'Chargement...'),
      ),
      error: (error, _) => Scaffold(
        body: ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(currentUserProvider);
          },
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    final pendingAsync = ref.watch(pendingValidationShortsProvider);
    final validatedAsync = ref.watch(validatedShortsProvider);
    final rejectedAsync = ref.watch(rejectedShortsProvider);

    final pendingCount = pendingAsync.valueOrNull?.length ?? 0;
    final validatedCount = validatedAsync.valueOrNull?.length ?? 0;
    final rejectedCount = rejectedAsync.valueOrNull?.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: context.cardBg,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              AppLocalizations.of(context)!.statsToValidate,
              pendingCount.toString(),
              Iconsax.clipboard_tick,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              AppLocalizations.of(context)!.statsValidated,
              validatedCount.toString(),
              Iconsax.tick_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              AppLocalizations.of(context)!.statsRejected,
              rejectedCount.toString(),
              Iconsax.close_circle,
              AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: context.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: context.cardBg,
      child: Row(
        children: [
          _buildTab(AppLocalizations.of(context)!.navToValidate, 0),
          _buildTab(AppLocalizations.of(context)!.navValidated, 1),
          _buildTab(AppLocalizations.of(context)!.navRejected, 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final selectedTabIndex = ref.watch(assistantTabIndexProvider);
    final isSelected = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(assistantTabIndexProvider.notifier).state = index;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : context.textTertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (ref.watch(assistantTabIndexProvider)) {
      case 0:
        return _buildPendingVideos();
      case 1:
        return _buildValidatedVideos();
      case 2:
        return _buildRejectedVideos();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPendingVideos() {
    final shortsAsync = ref.watch(pendingValidationShortsProvider);

    final l10n = AppLocalizations.of(context)!;
    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, l10n.emptyNoVideosToValidate),
      loading: () => LoadingIndicator(message: l10n.loadingVideos),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoadingVideos,
        onRetry: () => ref.invalidate(pendingValidationShortsProvider),
      ),
    );
  }

  Widget _buildValidatedVideos() {
    final shortsAsync = ref.watch(validatedShortsProvider);
    final l10n = AppLocalizations.of(context)!;

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, l10n.emptyNoValidatedVideos),
      loading: () => LoadingIndicator(message: l10n.loadingVideos),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoadingVideos,
        onRetry: () => ref.invalidate(validatedShortsProvider),
      ),
    );
  }

  Widget _buildRejectedVideos() {
    final shortsAsync = ref.watch(rejectedShortsProvider);
    final l10n = AppLocalizations.of(context)!;

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, l10n.emptyNoRejectedVideos),
      loading: () => LoadingIndicator(message: l10n.loadingVideos),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoadingVideos,
        onRetry: () => ref.invalidate(rejectedShortsProvider),
      ),
    );
  }

  Widget _buildVideoList(List<Short> allVideos, String emptyMessage) {
    final videos = _searchQuery.isEmpty
        ? allVideos
        : allVideos.where((s) {
            final query = _searchQuery.toLowerCase();
            return (s.title ?? '').toLowerCase().contains(query) ||
                s.videoId.toLowerCase().contains(query) ||
                s.sourceChannel.channelName.toLowerCase().contains(query) ||
                (s.assignedTo?.username ?? '').toLowerCase().contains(query);
          }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(pendingValidationShortsProvider);
        ref.invalidate(validatedShortsProvider);
        ref.invalidate(rejectedShortsProvider);
      },
      child: videos.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.video_slash, size: 64, color: AppColors.gray300),
                      const SizedBox(height: 16),
                      Text(
                        emptyMessage,
                        style: TextStyle(fontSize: 16, color: context.textTertiary),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return _buildVideoCard(videos[index]);
              },
            ),
    );
  }

  Widget _buildVideoCard(Short short) {
    final bool isPending = ref.watch(assistantTabIndexProvider) == 0;
    final thumbnailUrl = 'https://img.youtube.com/vi/${short.videoId}/mqdefault.jpg';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  thumbnailUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Iconsax.video, color: context.iconSubtle, size: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      short.title ?? short.videoId,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      short.sourceChannel.channelName,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textTertiary,
                      ),
                    ),
                    if (short.assignedTo != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Iconsax.user, color: context.iconSubtle, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            short.assignedTo!.username,
                            style: TextStyle(fontSize: 12, color: context.textHint),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.getStatusColor(short.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        short.statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getStatusColor(short.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (short.adminFeedback != null && short.adminFeedback!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ref.watch(assistantTabIndexProvider) == 2
                    ? AppColors.error.withValues(alpha: 0.05)
                    : AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ref.watch(assistantTabIndexProvider) == 2
                      ? AppColors.error.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                short.adminFeedback!,
                style: TextStyle(
                  fontSize: 13,
                  color: ref.watch(assistantTabIndexProvider) == 2 ? AppColors.error : AppColors.primary,
                ),
              ),
            ),
          ],
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRejectDialog(short),
                    icon: Icon(Iconsax.close_circle, size: 16, color: AppColors.error),
                    label: Text(AppLocalizations.of(context)!.actionReject),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showValidateDialog(short),
                    icon: const Icon(Iconsax.tick_circle, size: 16),
                    label: Text(AppLocalizations.of(context)!.actionValidate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.shortDetails, arguments: short.id);
                },
                icon: Icon(Iconsax.eye, size: 16, color: AppColors.primary),
                label: Text(AppLocalizations.of(context)!.commonViewDetails),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showValidateDialog(Short short) {
    final feedbackController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.dialogValidateTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.dialogValidateContent(short.title ?? short.videoId)),
                const SizedBox(height: 12),
                TextField(
                  controller: feedbackController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.dialogFeedbackHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        try {
                          final feedback = feedbackController.text.trim();
                          await ref.read(shortsServiceProvider).validateShort(
                                short.id,
                                feedback: feedback.isNotEmpty ? feedback : null,
                              );
                          ref.invalidate(pendingValidationShortsProvider);
                          ref.invalidate(validatedShortsProvider);
                          if (dialogContext.mounted) Navigator.pop(dialogContext);
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.snackVideoValidated),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() => isLoading = false);
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.commonErrorPrefix(e.toString())),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.actionValidate),
              ),
            ],
          );
        },
      );
      },
    );
  }

  void _showRejectDialog(Short short) {
    final reasonController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;
        String? errorText;
        return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.dialogRejectTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.dialogRejectReasonLabel),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.dialogRejectHint,
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final reason = reasonController.text.trim();
                        if (reason.isEmpty) {
                          setState(() => errorText = l10n.dialogRejectReasonRequired);
                          return;
                        }
                        setState(() {
                          isLoading = true;
                          errorText = null;
                        });
                        try {
                          await ref.read(shortsServiceProvider).rejectShort(short.id, reason);
                          ref.invalidate(pendingValidationShortsProvider);
                          ref.invalidate(rejectedShortsProvider);
                          if (dialogContext.mounted) Navigator.pop(dialogContext);
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.snackVideoRejected),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() => isLoading = false);
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.commonErrorPrefix(e.toString())),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.actionReject),
              ),
            ],
          );
        },
      );
      },
    );
  }
}
