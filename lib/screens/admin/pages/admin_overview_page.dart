// lib/screens/admin/pages/admin_overview_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../providers/shorts_provider.dart';
import '../../../widgets/common/loading_indicator.dart';

class AdminOverviewPage extends ConsumerWidget {
  const AdminOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          _buildStatsGrid(ref),
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

  Widget _buildStatsGrid(WidgetRef ref) {
    final statsAsync = ref.watch(shortsStatsProvider);

    return statsAsync.when(
      data: (stats) => GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
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
            color: Colors.black.withValues(alpha:0.05),
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
              color: color.withValues(alpha:0.1),
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
}
