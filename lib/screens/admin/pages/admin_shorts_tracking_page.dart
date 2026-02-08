// lib/screens/admin/pages/admin_shorts_tracking_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_extensions.dart';
import '../../../core/models/short.dart';
import '../../../providers/shorts_provider.dart';
import '../../../widgets/common/stat_badge.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/cards/short_tracking_card.dart';
import '../../../widgets/common/search_filter_bar.dart';
import '../../../widgets/modals/validate_short_modal.dart';
import '../../../widgets/modals/reject_short_modal.dart';
import '../../../config/routes/app_routes.dart';
import '../../../l10n/app_localizations.dart';

class AdminShortsTrackingPage extends ConsumerStatefulWidget {
  const AdminShortsTrackingPage({super.key});

  @override
  ConsumerState<AdminShortsTrackingPage> createState() => _AdminShortsTrackingPageState();
}

class _AdminShortsTrackingPageState extends ConsumerState<AdminShortsTrackingPage> {
  String _searchQuery = '';
  String _statusFilter = 'ALL';

  List<Short> _filterShorts(List<Short> shorts) {
    return shorts.where((s) {
      // Exclude ROLLED and RETAINED from tracking (they haven't entered the workflow yet)
      if (s.isRolled || s.isRetained) return false;

      // Status filter
      if (_statusFilter != 'ALL' && s.status != _statusFilter) return false;

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = (s.title ?? '').toLowerCase().contains(query);
        final matchesVideoId = s.videoId.toLowerCase().contains(query);
        final matchesSource = s.sourceChannel.channelName.toLowerCase().contains(query);
        final matchesTarget = (s.targetChannel?.channelName ?? '').toLowerCase().contains(query);
        final matchesVideaste = (s.assignedTo?.username ?? '').toLowerCase().contains(query);
        if (!matchesTitle && !matchesVideoId && !matchesSource && !matchesTarget && !matchesVideaste) {
          return false;
        }
      }

      return true;
    }).toList()
      ..sort((a, b) {
        // Sort: late first, then by most recent
        if (a.isLate && !b.isLate) return -1;
        if (!a.isLate && b.isLate) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
  }

  void _openValidateModal(Short short) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ValidateShortModal(short: short),
    );
  }

  void _openRejectModal(Short short) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RejectShortModal(short: short),
    );
  }

  void _publishShort(Short short) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        var isLoading = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            title: Text(l10n.dialogPublishTitle),
            content: Text(l10n.dialogPublishContent(short.title ?? short.videoId)),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(ctx),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        setDialogState(() => isLoading = true);
                        try {
                          await ref.read(shortsServiceProvider).publishShort(short.id);
                          ref.invalidate(shortsStatsProvider);
                          ref.invalidate(allShortsProvider);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                          }
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(l10n.publishSuccess),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } catch (e) {
                          setDialogState(() => isLoading = false);
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.commonErrorPrefix(e.toString())), backgroundColor: AppColors.error),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(l10n.actionPublish),
              ),
            ],
          ),
        );
      },
    );
  }

  void _viewShort(Short short) {
    Navigator.pushNamed(context, AppRoutes.shortDetails, arguments: short.id);
  }

  List<Map<String, String>> _getStatusOptions(AppLocalizations l10n) {
    return [
      {'value': 'ALL', 'label': l10n.trackingAllStatuses},
      {'value': 'ASSIGNED', 'label': l10n.statusAssigned},
      {'value': 'IN_PROGRESS', 'label': l10n.statusInProgress},
      {'value': 'COMPLETED', 'label': l10n.statusCompleted},
      {'value': 'VALIDATED', 'label': l10n.statusValidated},
      {'value': 'REJECTED', 'label': l10n.statusRejected},
      {'value': 'PUBLISHED', 'label': l10n.statusPublished},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final shortsAsync = ref.watch(allShortsProvider);
    final statsAsync = ref.watch(shortsStatsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildStatsRow(statsAsync),
        SearchFilterBar(
          hintText: l10n.trackingSearchHint,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          filterValue: _statusFilter,
          filterOptions: _getStatusOptions(l10n),
          onFilterChanged: (v) => setState(() => _statusFilter = v ?? 'ALL'),
        ),
        Expanded(
          child: shortsAsync.when(
            data: (shorts) {
              final filtered = _filterShorts(shorts);
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.document_text, size: 64, color: AppColors.gray300),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty || _statusFilter != 'ALL'
                            ? l10n.trackingNoShortsFiltered
                            : l10n.trackingNoShorts,
                        style: TextStyle(fontSize: 16, color: context.textTertiary),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(allShortsProvider);
                  ref.invalidate(shortsStatsProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final short = filtered[index];
                    return ShortTrackingCard(
                      short: short,
                      onView: () => _viewShort(short),
                      onValidate: short.isCompleted ? () => _openValidateModal(short) : null,
                      onReject: short.isCompleted ? () => _openRejectModal(short) : null,
                      onPublish: short.isValidated ? () => _publishShort(short) : null,
                    );
                  },
                ),
              );
            },
            loading: () => LoadingIndicator(message: l10n.trackingLoading),
            error: (error, _) => ErrorDisplay(
              message: l10n.trackingLoadingError,
              onRetry: () => ref.invalidate(allShortsProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(AsyncValue<ShortsStats> statsAsync) {
    final stats = statsAsync.valueOrNull;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            StatBadge(label: l10n.trackingStatsTotal, value: '${stats?.total ?? 0}', icon: Iconsax.document_text, color: AppColors.gray600),
            const SizedBox(width: 8),
            StatBadge(label: l10n.trackingStatsAssigned, value: '${stats?.assigned ?? 0}', icon: Iconsax.user_tick, color: AppColors.statusAssigned),
            const SizedBox(width: 8),
            StatBadge(label: l10n.trackingStatsInProgress, value: '${stats?.inProgress ?? 0}', icon: Iconsax.timer_1, color: AppColors.statusInProgress),
            const SizedBox(width: 8),
            StatBadge(label: l10n.trackingStatsCompleted, value: '${stats?.completed ?? 0}', icon: Iconsax.tick_circle, color: AppColors.statusCompleted),
            const SizedBox(width: 8),
            StatBadge(label: l10n.trackingStatsValidated, value: '${stats?.validated ?? 0}', icon: Iconsax.shield_tick, color: AppColors.statusValidated),
            const SizedBox(width: 8),
            StatBadge(label: l10n.trackingStatsRejected, value: '${stats?.rejected ?? 0}', icon: Iconsax.close_circle, color: AppColors.statusRejected),
            const SizedBox(width: 8),
            StatBadge(label: l10n.trackingStatsPublished, value: '${stats?.published ?? 0}', icon: Iconsax.global, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }

}

