// lib/screens/admin/pages/admin_channels_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_extensions.dart';
import '../../../providers/channels_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/cards/channel_card.dart';
import '../../../core/models/source_channel.dart';
import '../../../core/models/admin_channel.dart';
import '../../../widgets/common/search_filter_bar.dart';
import '../../../l10n/app_localizations.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            tabs: const [
              Tab(text: 'Canaux Sources'),
              Tab(text: 'Canaux de Publication'),
            ],
          ),
        ),

        // Search bar
        SearchFilterBar(
          hintText: l10n.channelSearchHint,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
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

    return channelsAsync.when(
      data: (allChannels) {
        final channels = _searchQuery.isEmpty
            ? allChannels
            : allChannels.where((c) => c.channelName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

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
                            _searchQuery.isNotEmpty ? 'Aucun canal trouve' : 'Aucun canal source',
                            style: TextStyle(fontSize: 16, color: context.textTertiary),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Ajoutez un canal pour commencer',
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
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.channelSelected(channel.channelName)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
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
        message: 'Erreur lors du chargement des canaux',
        onRetry: () => ref.invalidate(sourceChannelsProvider),
      ),
    );
  }

  Widget _buildAdminChannelsList() {
    final channelsAsync = ref.watch(adminChannelsProvider);

    return channelsAsync.when(
      data: (allChannels) {
        final channels = _searchQuery.isEmpty
            ? allChannels
            : allChannels.where((c) => c.channelName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

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
                            _searchQuery.isNotEmpty ? 'Aucun canal trouve' : 'Aucun canal de publication',
                            style: TextStyle(fontSize: 16, color: context.textTertiary),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Ajoutez un canal pour publier',
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
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.channelSelected(channel.channelName)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
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
        message: 'Erreur lors du chargement des canaux',
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
