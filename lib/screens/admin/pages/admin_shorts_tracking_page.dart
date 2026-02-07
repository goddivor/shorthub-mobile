// lib/screens/admin/pages/admin_shorts_tracking_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/short.dart';
import '../../../providers/shorts_provider.dart';
import '../../../widgets/common/stat_badge.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/cards/short_tracking_card.dart';
import '../../../widgets/modals/validate_short_modal.dart';
import '../../../widgets/modals/reject_short_modal.dart';
import '../../../config/routes/app_routes.dart';

class AdminShortsTrackingPage extends ConsumerStatefulWidget {
  const AdminShortsTrackingPage({super.key});

  @override
  ConsumerState<AdminShortsTrackingPage> createState() => _AdminShortsTrackingPageState();
}

class _AdminShortsTrackingPageState extends ConsumerState<AdminShortsTrackingPage> {
  String _searchQuery = '';
  String _statusFilter = 'ALL';

  final _statusOptions = const [
    {'value': 'ALL', 'label': 'Tous les statuts'},
    {'value': 'ASSIGNED', 'label': 'Assignes'},
    {'value': 'IN_PROGRESS', 'label': 'En cours'},
    {'value': 'COMPLETED', 'label': 'Termines'},
    {'value': 'VALIDATED', 'label': 'Valides'},
    {'value': 'REJECTED', 'label': 'Rejetes'},
    {'value': 'PUBLISHED', 'label': 'Publies'},
  ];

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
        var isLoading = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            title: const Text('Publier le short'),
            content: Text('Confirmer la publication de "${short.title ?? short.videoId}" ?'),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(ctx),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setDialogState(() => isLoading = true);
                        try {
                          await ref.read(shortsServiceProvider).publishShort(short.id);
                          ref.invalidate(shortsStatsProvider);
                          ref.invalidate(allShortsProvider);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Short publie avec succes !'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          setDialogState(() => isLoading = false);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Publier'),
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

  @override
  Widget build(BuildContext context) {
    final shortsAsync = ref.watch(allShortsProvider);
    final statsAsync = ref.watch(shortsStatsProvider);

    return Column(
      children: [
        _buildHeader(),
        _buildStatsRow(statsAsync),
        _buildSearchAndFilter(),
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
                            ? 'Aucun short correspond aux filtres'
                            : 'Aucun short dans le workflow',
                        style: TextStyle(fontSize: 16, color: AppColors.gray600),
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
            loading: () => const LoadingIndicator(message: 'Chargement des shorts...'),
            error: (error, _) => ErrorDisplay(
              message: 'Erreur chargement des shorts',
              onRetry: () => ref.invalidate(allShortsProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, Colors.deepPurple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.listChecks(PhosphorIconsStyle.fill), color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suivi des Shorts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Suivre et gerer le workflow des shorts',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AsyncValue<ShortsStats> statsAsync) {
    final stats = statsAsync.valueOrNull;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            StatBadge(label: 'Total', value: '${stats?.total ?? 0}', icon: Iconsax.document_text, color: AppColors.gray600),
            const SizedBox(width: 8),
            StatBadge(label: 'Assignes', value: '${stats?.assigned ?? 0}', icon: Iconsax.user_tick, color: AppColors.statusAssigned),
            const SizedBox(width: 8),
            StatBadge(label: 'En cours', value: '${stats?.inProgress ?? 0}', icon: Iconsax.timer_1, color: AppColors.statusInProgress),
            const SizedBox(width: 8),
            StatBadge(label: 'Termines', value: '${stats?.completed ?? 0}', icon: Iconsax.tick_circle, color: AppColors.statusCompleted),
            const SizedBox(width: 8),
            StatBadge(label: 'Valides', value: '${stats?.validated ?? 0}', icon: Iconsax.shield_tick, color: AppColors.statusValidated),
            const SizedBox(width: 8),
            StatBadge(label: 'Rejetes', value: '${stats?.rejected ?? 0}', icon: Iconsax.close_circle, color: AppColors.statusRejected),
            const SizedBox(width: 8),
            StatBadge(label: 'Publies', value: '${stats?.published ?? 0}', icon: Iconsax.global, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.gray400),
                prefixIcon: Icon(Iconsax.search_normal, size: 18, color: AppColors.gray400),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gray200),
                ),
                filled: true,
                fillColor: AppColors.gray50,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const SizedBox(width: 8),
          // Status filter
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray200),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.gray50,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _statusFilter,
                  isExpanded: true,
                  isDense: true,
                  style: TextStyle(fontSize: 12, color: AppColors.gray700),
                  icon: Icon(Iconsax.arrow_down_1, size: 16, color: AppColors.gray400),
                  items: _statusOptions.map((opt) => DropdownMenuItem(
                    value: opt['value'],
                    child: Text(opt['label']!, style: const TextStyle(fontSize: 12)),
                  )).toList(),
                  onChanged: (v) => setState(() => _statusFilter = v ?? 'ALL'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

