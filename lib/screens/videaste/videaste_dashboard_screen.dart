// lib/screens/videaste/videaste_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/short.dart';
import '../../core/models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';

class VideasteDashboardScreen extends ConsumerStatefulWidget {
  const VideasteDashboardScreen({super.key});

  @override
  ConsumerState<VideasteDashboardScreen> createState() => _VideasteDashboardScreenState();
}

class _VideasteDashboardScreenState extends ConsumerState<VideasteDashboardScreen> {
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
          appBar: _buildAppBar(user),
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

  PreferredSizeWidget _buildAppBar(User user) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tableau de bord',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          Text(
            'Bienvenue ${user.username}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Iconsax.notification, color: AppColors.gray700),
          onPressed: () {
            // TODO: Navigate to notifications
          },
        ),
        IconButton(
          icon: Icon(Iconsax.setting_2, color: AppColors.gray700),
          onPressed: () {
            // TODO: Navigate to settings
          },
        ),
        IconButton(
          icon: Icon(Iconsax.logout, color: AppColors.error),
          onPressed: () {
            ref.read(currentUserProvider.notifier).logout();
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          },
        ),
      ],
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
              'Assignées',
              stats?.totalVideosAssigned.toString() ?? '0',
              Iconsax.video_play,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Complétées',
              stats?.totalVideosCompleted.toString() ?? '0',
              Iconsax.tick_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Taux',
              '${stats?.completionRate.toStringAsFixed(0) ?? '0'}%',
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
          _buildTab('Assignées', 0),
          _buildTab('En cours', 1),
          _buildTab('Terminées', 2),
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
    // For now, showing placeholder content

    switch (_selectedTabIndex) {
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

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, 'Aucune vidéo assignée pour le moment'),
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(assignedShortsProvider),
      ),
    );
  }

  Widget _buildInProgressVideos() {
    final shortsAsync = ref.watch(inProgressShortsProvider);

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, 'Aucune vidéo en cours'),
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(inProgressShortsProvider),
      ),
    );
  }

  Widget _buildCompletedVideos() {
    final shortsAsync = ref.watch(completedShortsProvider);

    return shortsAsync.when(
      data: (shorts) => _buildVideoList(shorts, 'Aucune vidéo terminée'),
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(completedShortsProvider),
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
                    Row(
                      children: [
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
                        if (short.isLate) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Iconsax.clock,
                            size: 16,
                            color: AppColors.error,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Open video details
                  },
                  icon: Icon(Iconsax.eye, size: 16, color: AppColors.primary),
                  label: const Text('Voir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Start working on video
                  },
                  icon: const Icon(Iconsax.play, size: 16),
                  label: const Text('Travailler'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
