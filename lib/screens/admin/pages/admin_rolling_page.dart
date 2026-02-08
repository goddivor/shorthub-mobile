// lib/screens/admin/pages/admin_rolling_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_extensions.dart';
import '../../../core/models/source_channel.dart';
import '../../../core/models/short.dart';
import '../../../providers/shorts_provider.dart';
import '../../../providers/channels_provider.dart';
import '../../../widgets/common/stat_badge.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/modals/roll_short_modal.dart';
import '../../../widgets/modals/assign_short_modal.dart';
import '../../../l10n/app_localizations.dart';

class AdminRollingPage extends ConsumerStatefulWidget {
  const AdminRollingPage({super.key});

  @override
  ConsumerState<AdminRollingPage> createState() => _AdminRollingPageState();
}

class _AdminRollingPageState extends ConsumerState<AdminRollingPage> {
  String _languageFilter = 'ALL'; // ALL, VF, VA, VO
  String _editFilter = 'ALL'; // ALL, AVEC, SANS

  List<SourceChannel> _filterChannels(List<SourceChannel> channels) {
    return channels.where((c) {
      if (_languageFilter != 'ALL') {
        if (!c.contentType.startsWith(_languageFilter)) return false;
      }
      if (_editFilter != 'ALL') {
        if (_editFilter == 'AVEC' && !c.contentType.contains('AVEC')) return false;
        if (_editFilter == 'SANS' && !c.contentType.contains('SANS')) return false;
      }
      return true;
    }).toList();
  }

  void _openRollModal(SourceChannel channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RollShortModal(
        channel: channel,
        onRetained: (retainedShort) {
          _openAssignModal(retainedShort);
        },
      ),
    );
  }

  void _openAssignModal(Short short) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssignShortModal(short: short),
    );
  }

  void _randomRoll(List<SourceChannel> channels) {
    if (channels.isEmpty) return;
    final random = Random();
    final channel = channels[random.nextInt(channels.length)];
    _openRollModal(channel);
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(sourceChannelsProvider);
    final statsAsync = ref.watch(shortsStatsProvider);

    return Column(
      children: [
        _buildStatsRow(statsAsync),
        _buildFilters(),
        Expanded(
          child: channelsAsync.when(
            data: (channels) {
              final filtered = _filterChannels(channels);
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.video_slash, size: 64, color: AppColors.gray300),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.rollingNoChannels, style: TextStyle(fontSize: 16, color: context.textTertiary)),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _buildChannelCard(filtered[index]),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      heroTag: 'random_roll',
                      onPressed: () => _randomRoll(filtered),
                      backgroundColor: AppColors.secondary,
                      child: Icon(PhosphorIcons.shuffle(PhosphorIconsStyle.bold), color: Colors.white, size: 24),
                    ),
                  ),
                ],
              );
            },
            loading: () => LoadingIndicator(message: AppLocalizations.of(context)!.rollingLoadingChannels),
            error: (error, _) => ErrorDisplay(
              message: AppLocalizations.of(context)!.rollingLoadingError,
              onRetry: () => ref.invalidate(sourceChannelsProvider),
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
            StatBadge(label: l10n.rollingStatsRolled, value: '${stats?.rolled ?? 0}', icon: Iconsax.video_play, color: AppColors.gray600),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsRetained, value: '${stats?.retained ?? 0}', icon: Iconsax.archive_tick, color: AppColors.info),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsAssigned, value: '${stats?.assigned ?? 0}', icon: Iconsax.user_tick, color: AppColors.primary),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsInProgress, value: '${stats?.inProgress ?? 0}', icon: Iconsax.timer_1, color: AppColors.warning),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsCompleted, value: '${stats?.completed ?? 0}', icon: Iconsax.tick_circle, color: AppColors.success),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsValidated, value: '${stats?.validated ?? 0}', icon: Iconsax.shield_tick, color: Colors.teal),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsPublished, value: '${stats?.published ?? 0}', icon: Iconsax.global, color: Colors.deepPurple),
            const SizedBox(width: 8),
            StatBadge(label: l10n.rollingStatsRejected, value: '${stats?.rejected ?? 0}', icon: Iconsax.close_circle, color: AppColors.error),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.only(bottom: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Language group
            _buildFilterGroup([
              _buildFilterChip(l10n.filterAll, _languageFilter == 'ALL', () => setState(() => _languageFilter = 'ALL')),
              _buildFilterChip('VF', _languageFilter == 'VF', () => setState(() => _languageFilter = 'VF')),
              _buildFilterChip('VA', _languageFilter == 'VA', () => setState(() => _languageFilter = 'VA')),
              _buildFilterChip('VO', _languageFilter == 'VO', () => setState(() => _languageFilter = 'VO')),
            ]),
            const SizedBox(width: 10),
            // Edit group
            _buildFilterGroup([
              _buildFilterChip(l10n.filterAll, _editFilter == 'ALL', () => setState(() => _editFilter = 'ALL')),
              _buildFilterChip(l10n.filterWithEdit, _editFilter == 'AVEC', () => setState(() => _editFilter = 'AVEC')),
              _buildFilterChip(l10n.filterWithoutEdit, _editFilter == 'SANS', () => setState(() => _editFilter = 'SANS')),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGroup(List<Widget> chips) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.subtleBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: chips,
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : context.textTertiary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChannelCard(SourceChannel channel) {
    return GestureDetector(
      onTap: () => _openRollModal(channel),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar with generate button overlay
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: channel.profileImageUrl != null
                      ? NetworkImage(channel.profileImageUrl!)
                      : null,
                  backgroundColor: context.borderColor,
                  child: channel.profileImageUrl == null
                      ? Icon(Iconsax.video_circle, color: context.iconSubtle, size: 32)
                      : null,
                ),
                // Generate button
                Positioned(
                  top: -4,
                  right: -8,
                  child: GestureDetector(
                    onTap: () => _openRollModal(channel),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.cardBg, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        PhosphorIcons.shuffle(PhosphorIconsStyle.bold),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Channel name
            Text(
              channel.channelName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Video count
            if (channel.totalVideos != null)
              Text(
                '${channel.totalVideos} videos',
                style: TextStyle(fontSize: 11, color: context.textHint),
              ),
            const SizedBox(height: 6),
            // Content type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _getContentTypeColor(channel.contentType).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                channel.contentTypeLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: _getContentTypeColor(channel.contentType),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getContentTypeColor(String contentType) {
    if (contentType.startsWith('VA')) return AppColors.primary;
    if (contentType.startsWith('VF')) return AppColors.success;
    if (contentType.startsWith('VO')) return AppColors.secondary;
    return AppColors.gray500;
  }
}
