// lib/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../core/models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;

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
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavBar(),
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
            'Administration',
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
          icon: Icon(Iconsax.logout, color: AppColors.error),
          onPressed: () {
            ref.read(currentUserProvider.notifier).logout();
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildVideosTab();
      case 2:
        return _buildChannelsTab();
      case 3:
        return _buildUsersTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          _buildStatsGrid(),
          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Activité récente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final statsAsync = ref.watch(shortsStatsProvider);

    return statsAsync.when(
      data: (stats) => GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3, // Decreased to give more vertical height to cards
        children: [
          _buildStatCard(
            'Total vidéos',
            stats.total.toString(),
            Iconsax.video,
            AppColors.primary,
          ),
          _buildStatCard(
            'Roulées',
            stats.rolled.toString(),
            Iconsax.refresh,
            AppColors.statusRolled,
          ),
          _buildStatCard(
            'Assignées',
            stats.assigned.toString(),
            Iconsax.user_tag,
            AppColors.statusAssigned,
          ),
          _buildStatCard(
            'Publiées',
            stats.published.toString(),
            Iconsax.tick_circle,
            AppColors.success,
          ),
        ],
      ),
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Erreur lors du chargement des statistiques',
          style: TextStyle(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    // TODO: Replace with real data
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Iconsax.activity,
              size: 48,
              color: AppColors.gray300,
            ),
            const SizedBox(height: 12),
            Text(
              'Aucune activité récente',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    final shortsAsync = ref.watch(allShortsProvider);

    return shortsAsync.when(
      data: (shorts) {
        if (shorts.isEmpty) {
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
                  'Aucune vidéo disponible',
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
          itemCount: shorts.length,
          itemBuilder: (context, index) {
            final short = shorts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          short.videoId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          short.sourceChannel.channelName,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getStatusColor(short.status)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
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
            );
          },
        );
      },
      loading: () => const LoadingIndicator(message: 'Chargement des vidéos...'),
      error: (error, _) => ErrorDisplay(
        message: 'Erreur lors du chargement des vidéos',
        onRetry: () => ref.invalidate(allShortsProvider),
      ),
    );
  }

  Widget _buildChannelsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Canaux sources',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray900,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to add channel
                },
                icon: const Icon(Iconsax.add, size: 18),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Channels List
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Icon(
                  Iconsax.video_circle,
                  size: 64,
                  color: AppColors.gray300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun canal configuré',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Utilisateurs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray900,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to add user
                },
                icon: const Icon(Iconsax.user_add, size: 18),
                label: const Text('Inviter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Users List
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Icon(
                  Iconsax.people,
                  size: 64,
                  color: AppColors.gray300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun utilisateur',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray400,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: 'Aperçu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.video),
          label: 'Vidéos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.video_circle),
          label: 'Canaux',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.people),
          label: 'Équipe',
        ),
      ],
    );
  }
}
