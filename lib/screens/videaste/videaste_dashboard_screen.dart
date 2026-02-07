// lib/screens/videaste/videaste_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../core/models/short.dart';
import '../../core/models/user.dart';
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

class VideasteDashboardScreen extends ConsumerStatefulWidget {
  const VideasteDashboardScreen({super.key});

  @override
  ConsumerState<VideasteDashboardScreen> createState() => _VideasteDashboardScreenState();
}

class _VideasteDashboardScreenState extends ConsumerState<VideasteDashboardScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(child: Text(AppLocalizations.of(context)!.noUserConnected)),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(user: user),
          endDrawer: CustomDrawer(user: user),
          body: Column(
            children: [
              _buildStatsHeader(user),
              _buildTabBar(),
              SearchFilterBar(
                hintText: AppLocalizations.of(context)!.commonSearch,
                onSearchChanged: (v) => setState(() => _searchQuery = v),
              ),
              Expanded(child: _buildTabContent()),
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
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
      ),
    );
  }

  Widget _buildStatsHeader(User user) {
    final assignedAsync = ref.watch(assignedShortsProvider);
    final inProgressAsync = ref.watch(inProgressShortsProvider);
    final completedAsync = ref.watch(completedShortsProvider);

    final assignedCount = assignedAsync.valueOrNull?.length ?? 0;
    final inProgressCount = inProgressAsync.valueOrNull?.length ?? 0;
    final completedCount = completedAsync.valueOrNull?.length ?? 0;
    final total = assignedCount + inProgressCount + completedCount;
    final rate = total > 0 ? ((completedCount / total) * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: const EdgeInsets.all(16),
      color: context.cardBg,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              AppLocalizations.of(context)!.statsAssigned,
              assignedCount.toString(),
              Iconsax.video_play,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              AppLocalizations.of(context)!.statsCompleted,
              completedCount.toString(),
              Iconsax.tick_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              AppLocalizations.of(context)!.statsRate,
              '$rate%',
              Iconsax.chart_1,
              AppColors.info,
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
          _buildTab(AppLocalizations.of(context)!.navAssigned, 0),
          _buildTab(AppLocalizations.of(context)!.navInProgress, 1),
          _buildTab(AppLocalizations.of(context)!.navCompleted, 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final selectedTabIndex = ref.watch(videasteTabIndexProvider);
    final isSelected = selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(videasteTabIndexProvider.notifier).state = index,
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
    switch (ref.watch(videasteTabIndexProvider)) {
      case 0:
        return _buildAssignedVideos();
      case 1:
        return _buildInProgressVideos();
      case 2:
        return _buildCompletedVideos();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAssignedVideos() {
    final shortsAsync = ref.watch(assignedShortsProvider);
    final l10n = AppLocalizations.of(context)!;
    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, l10n.emptyNoAssignedVideos),
      loading: () => LoadingIndicator(message: l10n.loading),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoading,
        onRetry: () => ref.invalidate(assignedShortsProvider),
      ),
    );
  }

  Widget _buildInProgressVideos() {
    final shortsAsync = ref.watch(inProgressShortsProvider);
    final l10n = AppLocalizations.of(context)!;
    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, l10n.emptyNoInProgressVideos),
      loading: () => LoadingIndicator(message: l10n.loading),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoading,
        onRetry: () => ref.invalidate(inProgressShortsProvider),
      ),
    );
  }

  Widget _buildCompletedVideos() {
    final shortsAsync = ref.watch(completedShortsProvider);
    final l10n = AppLocalizations.of(context)!;
    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, l10n.emptyNoCompletedVideos),
      loading: () => LoadingIndicator(message: l10n.loading),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoading,
        onRetry: () => ref.invalidate(completedShortsProvider),
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
                s.sourceChannel.channelName.toLowerCase().contains(query);
          }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(assignedShortsProvider);
        ref.invalidate(inProgressShortsProvider);
        ref.invalidate(completedShortsProvider);
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
                      Text(emptyMessage, style: TextStyle(fontSize: 16, color: context.textTertiary)),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (context, index) => _buildVideoCard(videos[index]),
            ),
    );
  }

  Widget _buildVideoCard(Short short) {
    final thumbnailUrl = 'https://img.youtube.com/vi/${short.videoId}/mqdefault.jpg';
    final dateFormat = DateFormat('dd/MM/yyyy', 'fr');

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
                      style: TextStyle(fontSize: 14, color: context.textTertiary),
                    ),
                    if (short.targetChannel != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Iconsax.arrow_right_3, color: context.iconSubtle, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              short.targetChannel!.channelName,
                              style: TextStyle(fontSize: 12, color: context.textHint),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                        if (short.isLate) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Iconsax.clock, size: 12, color: AppColors.error),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.shortLate,
                                  style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (short.deadline != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Iconsax.calendar_1, size: 14, color: context.iconSubtle),
                const SizedBox(width: 4),
                Text(
                  'Deadline: ${dateFormat.format(short.deadline!)}',
                  style: TextStyle(fontSize: 12, color: context.textHint),
                ),
              ],
            ),
          ],
          if (short.notes != null && short.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
              ),
              child: Text(
                short.notes!,
                style: TextStyle(fontSize: 12, color: AppColors.info),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 12),
          _buildActionButtons(short),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Short short) {
    switch (ref.watch(videasteTabIndexProvider)) {
      case 0: // Assigned
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.shortDetails, arguments: short.id),
                icon: Icon(Iconsax.eye, size: 16, color: AppColors.primary),
                label: Text(AppLocalizations.of(context)!.commonView),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showStartWorkDialog(short),
                icon: const Icon(Iconsax.play, size: 16),
                label: Text(AppLocalizations.of(context)!.actionWork),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      case 1: // In Progress
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.shortDetails, arguments: short.id),
                icon: Icon(Iconsax.eye, size: 16, color: AppColors.primary),
                label: Text(AppLocalizations.of(context)!.commonView),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showCompleteDialog(short),
                icon: const Icon(Iconsax.tick_circle, size: 16),
                label: Text(AppLocalizations.of(context)!.actionComplete),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      case 2: // Completed
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.shortDetails, arguments: short.id),
            icon: Icon(Iconsax.eye, size: 16, color: AppColors.primary),
            label: Text(AppLocalizations.of(context)!.commonView),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  void _showStartWorkDialog(Short short) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.dialogStartWorkTitle),
              content: Text(l10n.dialogStartWorkContentNamed(short.title ?? short.videoId)),
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
                            await ref.read(shortsServiceProvider).startWorkOnShort(short.id);
                            ref.invalidate(assignedShortsProvider);
                            ref.invalidate(inProgressShortsProvider);
                            if (dialogContext.mounted) Navigator.pop(dialogContext);
                            if (mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.snackWorkStarted),
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
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l10n.actionStart),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCompleteDialog(Short short) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.dialogCompleteTitle),
              content: Text(l10n.dialogCompleteContentNamed(short.title ?? short.videoId)),
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
                            await ref.read(shortsServiceProvider).completeShort(short.id);
                            ref.invalidate(inProgressShortsProvider);
                            ref.invalidate(completedShortsProvider);
                            if (dialogContext.mounted) Navigator.pop(dialogContext);
                            if (mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.snackVideoCompleted),
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
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l10n.actionComplete),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
