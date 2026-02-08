// lib/screens/admin/pages/admin_channels_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_extensions.dart';
import '../../../providers/channels_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/cards/channel_card.dart';
import '../../../core/models/source_channel.dart';
import '../../../core/models/admin_channel.dart';
import '../../../l10n/app_localizations.dart';

enum SortOption { lastAdded, nameAZ, nameZA, mostVideos, leastVideos }

class AdminChannelsPage extends ConsumerStatefulWidget {
  final Function(int)? onTabChanged;

  const AdminChannelsPage({super.key, this.onTabChanged});

  @override
  ConsumerState<AdminChannelsPage> createState() => _AdminChannelsPageState();

  // Methodes statiques pour afficher les dialogs
  static void showAddSourceChannelDialog(BuildContext context, WidgetRef ref) {
    _showAddSourceChannelDialog(context, ref);
  }

  static void showAddAdminChannelDialog(BuildContext context, WidgetRef ref) {
    _showAddAdminChannelDialog(context, ref);
  }

  // ==================== Channel Management Dialogs ====================

  static void _showAddSourceChannelDialog(BuildContext context, WidgetRef ref) {
    final youtubeUrlController = TextEditingController();
    String selectedContentType = 'VA_SANS_EDIT';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Row(
              children: [
                Icon(Iconsax.add_circle, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(l10n.channelAddSource),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.channelUrlHelp,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: youtubeUrlController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.channelUrlLabel,
                      hintText: '${l10n.channelUrlHint}\nou\nhttps://youtube.com/watch?v=...',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.link),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedContentType,
                    decoration: InputDecoration(
                      labelText: l10n.channelContentType,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.category),
                    ),
                    items: [
                      DropdownMenuItem(value: 'VA_SANS_EDIT', child: Text(l10n.contentTypeVaSansEdit)),
                      DropdownMenuItem(value: 'VA_AVEC_EDIT', child: Text(l10n.contentTypeVaAvecEdit)),
                      DropdownMenuItem(value: 'VF_SANS_EDIT', child: Text(l10n.contentTypeVfSansEdit)),
                      DropdownMenuItem(value: 'VF_AVEC_EDIT', child: Text(l10n.contentTypeVfAvecEdit)),
                      DropdownMenuItem(value: 'VO_SANS_EDIT', child: Text(l10n.contentTypeVoSansEdit)),
                      DropdownMenuItem(value: 'VO_AVEC_EDIT', child: Text(l10n.contentTypeVoAvecEdit)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedContentType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (youtubeUrlController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.channelUrlRequired),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        try {
                          final service = ref.read(channelsServiceProvider);
                          final channel = await service.createSourceChannel(
                            youtubeUrl: youtubeUrlController.text.trim(),
                            contentType: selectedContentType,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            ref.invalidate(sourceChannelsProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.channelAddedSuccess(channel.channelName)),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.commonErrorPrefix(e.toString())),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (context.mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(l10n.commonAdd),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showAddAdminChannelDialog(BuildContext context, WidgetRef ref) {
    final youtubeUrlController = TextEditingController();
    String selectedContentType = 'VA_SANS_EDIT';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Row(
              children: [
                Icon(Iconsax.add_circle, color: AppColors.success),
                const SizedBox(width: 12),
                Text(l10n.channelAddPub),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.channelUrlHelp,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: youtubeUrlController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.channelUrlLabel,
                      hintText: l10n.channelUrlHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.link),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedContentType,
                    decoration: InputDecoration(
                      labelText: l10n.channelContentType,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.category),
                    ),
                    items: [
                      DropdownMenuItem(value: 'VA_SANS_EDIT', child: Text(l10n.contentTypeVaSansEdit)),
                      DropdownMenuItem(value: 'VA_AVEC_EDIT', child: Text(l10n.contentTypeVaAvecEdit)),
                      DropdownMenuItem(value: 'VF_SANS_EDIT', child: Text(l10n.contentTypeVfSansEdit)),
                      DropdownMenuItem(value: 'VF_AVEC_EDIT', child: Text(l10n.contentTypeVfAvecEdit)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedContentType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (youtubeUrlController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.channelUrlRequired),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setState(() => isLoading = true);

                        try {
                          final service = ref.read(channelsServiceProvider);
                          final channel = await service.createAdminChannel(
                            youtubeUrl: youtubeUrlController.text.trim(),
                            contentType: selectedContentType,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            ref.invalidate(adminChannelsProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.channelAddedSuccess(channel.channelName)),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.commonErrorPrefix(e.toString())),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (context.mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(l10n.commonAdd),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminChannelsPageState extends ConsumerState<AdminChannelsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _searchExpanded = false;
  SortOption _sortOption = SortOption.lastAdded;
  String? _filterContentType;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ==================== Sort & Filter Logic ====================

  List<T> _applySortAndFilter<T>(
    List<T> items, {
    required String Function(T) getName,
    required int? Function(T) getVideos,
    required String Function(T) getContentType,
  }) {
    var result = List<T>.from(items);

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((c) => getName(c).toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by content type
    if (_filterContentType != null) {
      result = result.where((c) => getContentType(c) == _filterContentType).toList();
    }

    // Sort
    switch (_sortOption) {
      case SortOption.lastAdded:
        // Keep original order (most recent first from API)
        break;
      case SortOption.nameAZ:
        result.sort((a, b) => getName(a).toLowerCase().compareTo(getName(b).toLowerCase()));
        break;
      case SortOption.nameZA:
        result.sort((a, b) => getName(b).toLowerCase().compareTo(getName(a).toLowerCase()));
        break;
      case SortOption.mostVideos:
        result.sort((a, b) => (getVideos(b) ?? 0).compareTo(getVideos(a) ?? 0));
        break;
      case SortOption.leastVideos:
        result.sort((a, b) => (getVideos(a) ?? 0).compareTo(getVideos(b) ?? 0));
        break;
    }

    return result;
  }

  void _showSortBottomSheet() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.sortTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSortOption(l10n.sortLastAdded, Iconsax.calendar, SortOption.lastAdded),
                _buildSortOption(l10n.sortNameAZ, Iconsax.sort, SortOption.nameAZ),
                _buildSortOption(l10n.sortNameZA, Iconsax.sort, SortOption.nameZA),
                _buildSortOption(l10n.sortMostVideos, Iconsax.video_play, SortOption.mostVideos),
                _buildSortOption(l10n.sortLeastVideos, Iconsax.video_slash, SortOption.leastVideos),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, IconData icon, SortOption option) {
    final isSelected = _sortOption == option;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : context.iconSubtle,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : context.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      trailing: isSelected
          ? Icon(Iconsax.tick_circle, color: AppColors.primary, size: 20)
          : null,
      onTap: () {
        setState(() => _sortOption = option);
        Navigator.pop(context);
      },
    );
  }

  void _showFilterBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    final isSourceTab = _tabController.index == 0;

    final types = isSourceTab
        ? [
            ('VA_SANS_EDIT', l10n.contentTypeVaSansEdit),
            ('VA_AVEC_EDIT', l10n.contentTypeVaAvecEdit),
            ('VF_SANS_EDIT', l10n.contentTypeVfSansEdit),
            ('VF_AVEC_EDIT', l10n.contentTypeVfAvecEdit),
            ('VO_SANS_EDIT', l10n.contentTypeVoSansEdit),
            ('VO_AVEC_EDIT', l10n.contentTypeVoAvecEdit),
          ]
        : [
            ('VA_SANS_EDIT', l10n.contentTypeVaSansEdit),
            ('VA_AVEC_EDIT', l10n.contentTypeVaAvecEdit),
            ('VF_SANS_EDIT', l10n.contentTypeVfSansEdit),
            ('VF_AVEC_EDIT', l10n.contentTypeVfAvecEdit),
          ];

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.filterByType,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // "All" option
                _buildFilterOption(l10n.filterAll, null),
                ...types.map((t) => _buildFilterOption(t.$2, t.$1)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String? value) {
    final isSelected = _filterContentType == value;
    Color badgeColor;
    if (value == null) {
      badgeColor = AppColors.gray500;
    } else if (value.startsWith('VA')) {
      badgeColor = AppColors.primary;
    } else if (value.startsWith('VF')) {
      badgeColor = AppColors.success;
    } else {
      badgeColor = AppColors.secondary;
    }

    return ListTile(
      leading: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : context.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      trailing: isSelected
          ? Icon(Iconsax.tick_circle, color: AppColors.primary, size: 20)
          : null,
      onTap: () {
        setState(() => _filterContentType = value);
        Navigator.pop(context);
      },
    );
  }

  // ==================== Build ====================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasActiveFilter = _filterContentType != null;

    return Column(
      children: [
        // Tab Bar
        Container(
          color: context.cardBg,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: context.textTertiary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(text: l10n.channelSourcesTab),
              Tab(text: l10n.channelPubTab),
            ],
          ),
        ),

        // Search + Sort/Filter bar
        Container(
          color: context.cardBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Search button / expanded search
              if (_searchExpanded)
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.subtleBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(
                          Iconsax.search_normal,
                          size: 18,
                          color: context.textTertiary,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 20,
                          color: context.borderColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: TextStyle(
                              fontSize: 14,
                              color: context.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchExpanded = false;
                              _searchQuery = '';
                              _searchController.clear();
                              _searchFocusNode.unfocus();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: context.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Container(
                  width: 56,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.subtleBg,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        setState(() => _searchExpanded = true);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _searchFocusNode.requestFocus();
                        });
                      },
                      child: Center(
                        child: Icon(
                          Iconsax.search_normal,
                          size: 20,
                          color: context.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],

              const SizedBox(width: 12),

              // Sort + Filter combined pill
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: context.subtleBg,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sort button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(22),
                        ),
                        onTap: _showSortBottomSheet,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(
                            PhosphorIcons.sortAscending(PhosphorIconsStyle.bold),
                            size: 20,
                            color: _sortOption != SortOption.lastAdded
                                ? AppColors.primary
                                : context.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    // Divider
                    Container(
                      width: 1,
                      height: 20,
                      color: context.borderColor,
                    ),
                    // Filter button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(22),
                        ),
                        onTap: _showFilterBottomSheet,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                PhosphorIcons.funnel(PhosphorIconsStyle.bold),
                                size: 20,
                                color: hasActiveFilter
                                    ? AppColors.primary
                                    : context.textSecondary,
                              ),
                              if (hasActiveFilter)
                                Positioned(
                                  top: -2,
                                  right: -4,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSourceChannelsList(),
              _buildAdminChannelsList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSourceChannelsList() {
    final channelsAsync = ref.watch(sourceChannelsProvider);
    final l10n = AppLocalizations.of(context)!;

    return channelsAsync.when(
      data: (allChannels) {
        final channels = _applySortAndFilter<SourceChannel>(
          allChannels,
          getName: (c) => c.channelName,
          getVideos: (c) => c.totalVideos,
          getContentType: (c) => c.contentType,
        );

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(sourceChannelsProvider),
          child: channels.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.video_circle, size: 64, color: context.iconSubtle),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty || _filterContentType != null
                                ? l10n.channelNoResults
                                : l10n.channelNoSource,
                            style: TextStyle(fontSize: 16, color: context.textTertiary),
                          ),
                          if (_searchQuery.isEmpty && _filterContentType == null) ...[
                            const SizedBox(height: 8),
                            Text(
                              l10n.channelAddToStart,
                              style: TextStyle(fontSize: 14, color: context.textHint),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return ChannelCard(
                      id: channel.id,
                      channelId: channel.channelId,
                      channelName: channel.channelName,
                      profileImageUrl: channel.profileImageUrl,
                      contentType: channel.contentType,
                      totalVideos: channel.totalVideos,
                      isSourceChannel: true,
                      onEdit: () {
                        _showEditSourceChannelDialog(channel);
                      },
                      onDelete: () {
                        _showDeleteSourceChannelDialog(channel);
                      },
                    );
                  },
                ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Chargement des canaux...'),
      error: (error, _) => ErrorDisplay(
        message: l10n.channelLoadingError,
        onRetry: () => ref.invalidate(sourceChannelsProvider),
      ),
    );
  }

  Widget _buildAdminChannelsList() {
    final channelsAsync = ref.watch(adminChannelsProvider);
    final l10n = AppLocalizations.of(context)!;

    return channelsAsync.when(
      data: (allChannels) {
        final channels = _applySortAndFilter<AdminChannel>(
          allChannels,
          getName: (c) => c.channelName,
          getVideos: (c) => c.totalVideos,
          getContentType: (c) => c.contentType ?? '',
        );

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminChannelsProvider),
          child: channels.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.video_circle, size: 64, color: context.iconSubtle),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty || _filterContentType != null
                                ? l10n.channelNoResults
                                : l10n.channelNoPub,
                            style: TextStyle(fontSize: 16, color: context.textTertiary),
                          ),
                          if (_searchQuery.isEmpty && _filterContentType == null) ...[
                            const SizedBox(height: 8),
                            Text(
                              l10n.channelAddToPublish,
                              style: TextStyle(fontSize: 14, color: context.textHint),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return ChannelCard(
                      id: channel.id,
                      channelId: channel.channelId,
                      channelName: channel.channelName,
                      profileImageUrl: channel.profileImageUrl,
                      contentType: channel.contentType,
                      totalVideos: channel.totalVideos,
                      subscriberCount: channel.subscriberCount,
                      isSourceChannel: false,
                      onDelete: () {
                        _showDeleteAdminChannelDialog(channel);
                      },
                    );
                  },
                ),
        );
      },
      loading: () => const LoadingIndicator(message: 'Chargement des canaux...'),
      error: (error, _) => ErrorDisplay(
        message: l10n.channelLoadingError,
        onRetry: () => ref.invalidate(adminChannelsProvider),
      ),
    );
  }

  // ==================== Channel Management Dialogs ====================

  void _showEditSourceChannelDialog(SourceChannel channel) {
    String selectedContentType = channel.contentType;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Row(
              children: [
                Icon(Iconsax.edit, color: AppColors.info),
                const SizedBox(width: 12),
                Text(l10n.channelEditTitle),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.channelName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedContentType,
                  decoration: InputDecoration(
                    labelText: l10n.channelContentType,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Iconsax.category),
                  ),
                  items: [
                    DropdownMenuItem(value: 'VA_SANS_EDIT', child: Text(l10n.contentTypeVaSansEdit)),
                    DropdownMenuItem(value: 'VA_AVEC_EDIT', child: Text(l10n.contentTypeVaAvecEdit)),
                    DropdownMenuItem(value: 'VF_SANS_EDIT', child: Text(l10n.contentTypeVfSansEdit)),
                    DropdownMenuItem(value: 'VF_AVEC_EDIT', child: Text(l10n.contentTypeVfAvecEdit)),
                    DropdownMenuItem(value: 'VO_SANS_EDIT', child: Text(l10n.contentTypeVoSansEdit)),
                    DropdownMenuItem(value: 'VO_AVEC_EDIT', child: Text(l10n.contentTypeVoAvecEdit)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedContentType = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);

                        try {
                          final service = ref.read(channelsServiceProvider);
                          await service.updateSourceChannel(
                            id: channel.id,
                            contentType: selectedContentType,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            ref.invalidate(sourceChannelsProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.channelEditSuccess),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.commonErrorPrefix(e.toString())),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        } finally {
                          if (context.mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.info,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(l10n.commonEdit),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteSourceChannelDialog(SourceChannel channel) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Iconsax.warning_2, color: AppColors.error),
              const SizedBox(width: 12),
              Text(l10n.channelDeleteTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.channelDeleteConfirm(channel.channelName)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.info_circle, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Cette action est irr\u00e9versible',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final service = ref.read(channelsServiceProvider);
                  await service.deleteSourceChannel(channel.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.invalidate(sourceChannelsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.channelDeleted(channel.channelName)),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.commonErrorPrefix(e.toString())),
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
              child: Text(l10n.commonDelete),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAdminChannelDialog(AdminChannel channel) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Iconsax.warning_2, color: AppColors.error),
              const SizedBox(width: 12),
              Text(l10n.channelDeleteTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.channelDeleteConfirm(channel.channelName)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.info_circle, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Cette action est irr\u00e9versible',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final service = ref.read(channelsServiceProvider);
                  await service.deleteAdminChannel(channel.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.invalidate(adminChannelsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.channelDeleted(channel.channelName)),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.commonErrorPrefix(e.toString())),
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
              child: Text(l10n.commonDelete),
            ),
          ],
        );
      },
    );
  }
}
