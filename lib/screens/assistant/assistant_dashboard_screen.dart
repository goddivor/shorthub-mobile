// lib/screens/assistant/assistant_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../core/models/short.dart';
import '../../core/models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_drawer.dart';

class AssistantDashboardScreen extends ConsumerStatefulWidget {
  const AssistantDashboardScreen({super.key});

  @override
  ConsumerState<AssistantDashboardScreen> createState() => _AssistantDashboardScreenState();
}

class _AssistantDashboardScreenState extends ConsumerState<AssistantDashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text('Aucun utilisateur connecté'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(user: user),
          endDrawer: CustomDrawer(user: user),
          body: Column(
            children: [
              _buildStatsHeader(user),
              _buildTabBar(),
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


  Widget _buildStatsHeader(User user) {
    final stats = user.stats;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'À valider',
              '0', // TODO: stats?.pendingValidation.toString() ?? '0'
              Iconsax.clipboard_tick,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Validées',
              stats?.totalVideosCompleted.toString() ?? '0',
              Iconsax.tick_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Rejetées',
              '0', // TODO: stats?.totalRejected.toString() ?? '0'
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
              color: AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTab('À valider', 0),
          _buildTab('Validées', 1),
          _buildTab('Rejetées', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
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
              color: isSelected ? AppColors.primary : AppColors.gray600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    // TODO: Fetch real data from GraphQL

    switch (_selectedTabIndex) {
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

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, 'Aucune vidéo à valider'),
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(pendingValidationShortsProvider),
      ),
    );
  }

  Widget _buildValidatedVideos() {
    final shortsAsync = ref.watch(validatedShortsProvider);

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, 'Aucune vidéo validée'),
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(validatedShortsProvider),
      ),
    );
  }

  Widget _buildRejectedVideos() {
    final shortsAsync = ref.watch(rejectedShortsProvider);

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, 'Aucune vidéo rejetée'),
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(rejectedShortsProvider),
      ),
    );
  }

  Widget _buildVideoList(List<Short> videos, String emptyMessage) {
    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.video_slash,
              size: 64,
              color: AppColors.gray300,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(videos[index]);
      },
    );
  }

  Widget _buildVideoCard(Short short) {
    final bool isPending = _selectedTabIndex == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              // Thumbnail placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.video,
                  color: AppColors.gray400,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      short.videoId,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      short.sourceChannel.channelName,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getStatusColor(short.status)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        short.status,
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
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Reject video
                      _showRejectDialog(short);
                    },
                    icon: Icon(Iconsax.close_circle, size: 16, color: AppColors.error),
                    label: const Text('Rejeter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Validate video
                      _showValidateDialog(short);
                    },
                    icon: const Icon(Iconsax.tick_circle, size: 16),
                    label: const Text('Valider'),
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
                  // TODO: View video details
                },
                icon: Icon(Iconsax.eye, size: 16, color: AppColors.primary),
                label: const Text('Voir les détails'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider la vidéo'),
        content: const Text('Êtes-vous sûr de vouloir valider cette vidéo ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call GraphQL mutation to validate
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Vidéo validée avec succès'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(Short short) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter la vidéo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Raison du rejet :'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Expliquez pourquoi vous rejetez cette vidéo...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call GraphQL mutation to reject
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Vidéo rejetée'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Rejeter'),
          ),
        ],
      ),
    );
  }
}
