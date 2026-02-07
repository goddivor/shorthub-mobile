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
                      Text('Aucune chaine source', style: TextStyle(fontSize: 16, color: context.textTertiary)),
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
                      childAspectRatio: 0.85,
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
            loading: () => const LoadingIndicator(message: 'Chargement des chaines...'),
            error: (error, _) => ErrorDisplay(
              message: 'Erreur chargement des chaines',
              onRetry: () => ref.invalidate(sourceChannelsProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(AsyncValue<ShortsStats> statsAsync) {
    final stats = statsAsync.valueOrNull;

    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            StatBadge(label: 'Rolles', value: '${stats?.rolled ?? 0}', icon: Iconsax.video_play, color: AppColors.gray600),
            const SizedBox(width: 8),
            StatBadge(label: 'Retenus', value: '${stats?.retained ?? 0}', icon: Iconsax.archive_tick, color: AppColors.info),
            const SizedBox(width: 8),
            StatBadge(label: 'Assignes', value: '${stats?.assigned ?? 0}', icon: Iconsax.user_tick, color: AppColors.primary),
            const SizedBox(width: 8),
            StatBadge(label: 'En cours', value: '${stats?.inProgress ?? 0}', icon: Iconsax.timer_1, color: AppColors.warning),
            const SizedBox(width: 8),
            StatBadge(label: 'Termines', value: '${stats?.completed ?? 0}', icon: Iconsax.tick_circle, color: AppColors.success),
            const SizedBox(width: 8),
            StatBadge(label: 'Valides', value: '${stats?.validated ?? 0}', icon: Iconsax.shield_tick, color: Colors.teal),
            const SizedBox(width: 8),
            StatBadge(label: 'Publies', value: '${stats?.published ?? 0}', icon: Iconsax.global, color: Colors.deepPurple),
            const SizedBox(width: 8),
            StatBadge(label: 'Rejetes', value: '${stats?.rejected ?? 0}', icon: Iconsax.close_circle, color: AppColors.error),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip('Tous', _languageFilter == 'ALL', () => setState(() => _languageFilter = 'ALL')),
              _buildFilterChip('VF', _languageFilter == 'VF', () => setState(() => _languageFilter = 'VF')),
              _buildFilterChip('VA', _languageFilter == 'VA', () => setState(() => _languageFilter = 'VA')),
              _buildFilterChip('VO', _languageFilter == 'VO', () => setState(() => _languageFilter = 'VO')),
              const SizedBox(width: 8),
              _buildFilterChip('Tous', _editFilter == 'ALL', () => setState(() => _editFilter = 'ALL')),
              _buildFilterChip('Avec Edit', _editFilter == 'AVEC', () => setState(() => _editFilter = 'AVEC')),
              _buildFilterChip('Sans Edit', _editFilter == 'SANS', () => setState(() => _editFilter = 'SANS')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : context.textTertiary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        backgroundColor: selected ? AppColors.primary : context.chipBg,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildChannelCard(SourceChannel channel) {
    return GestureDetector(
      onTap: () => _openRollModal(channel),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
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
            CircleAvatar(
              radius: 30,
              backgroundImage: channel.profileImageUrl != null
                  ? NetworkImage(channel.profileImageUrl!)
                  : null,
              backgroundColor: context.borderColor,
              child: channel.profileImageUrl == null
                  ? Icon(Iconsax.video_circle, color: context.iconSubtle, size: 28)
                  : null,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                channel.contentTypeLabel,
                style: TextStyle(fontSize: 9, color: AppColors.secondary, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              channel.channelName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (channel.totalVideos != null) ...[
              const SizedBox(height: 4),
              Text(
                '${channel.totalVideos} videos',
                style: TextStyle(fontSize: 11, color: context.textHint),
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openRollModal(channel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                child: const Text('Generer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
