// lib/screens/shared/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/modals/change_password_modal.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text(AppLocalizations.of(context)!.userNotConnected));
          }

          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user.profileImage == null || user.profileImage!.isEmpty
                                ? Text(
                                    user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user.username,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              user.role ?? 'N/A',
                              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account info
                      _buildSection(
                        context,
                        title: AppLocalizations.of(context)!.profileAccountInfo,
                        icon: Iconsax.user,
                        child: Column(
                          children: [
                            _buildInfoRow(context, AppLocalizations.of(context)!.profileEmail, user.email ?? 'N/A'),
                            _buildInfoRow(context, AppLocalizations.of(context)!.profilePhone, user.phone ?? 'N/A'),
                            _buildInfoRow(context, AppLocalizations.of(context)!.profileStatus, user.isActive ? AppLocalizations.of(context)!.profileActive : AppLocalizations.of(context)!.profileBlocked),
                            if (user.lastLogin != null)
                              _buildInfoRow(context, AppLocalizations.of(context)!.profileLastLogin, dateFormat.format(user.lastLogin!)),
                            if (user.createdAt != null)
                              _buildInfoRow(context, AppLocalizations.of(context)!.profileMemberSince, dateFormat.format(user.createdAt!)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats (for videaste)
                      if (user.stats != null) ...[
                        _buildSection(
                          context,
                          title: AppLocalizations.of(context)!.profileStats,
                          icon: Iconsax.chart_1,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _buildStatCard(context, AppLocalizations.of(context)!.profileStatsAssigned, '${user.stats!.totalVideosAssigned}', AppColors.primary),
                                  const SizedBox(width: 8),
                                  _buildStatCard(context, AppLocalizations.of(context)!.profileStatsCompleted, '${user.stats!.totalVideosCompleted}', AppColors.success),
                                  const SizedBox(width: 8),
                                  _buildStatCard(context, AppLocalizations.of(context)!.profileStatsInProgress, '${user.stats!.totalVideosInProgress}', AppColors.warning),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildStatCard(context, AppLocalizations.of(context)!.profileStatsRate, '${user.stats!.completionRate.toStringAsFixed(0)}%', AppColors.info),
                                  const SizedBox(width: 8),
                                  _buildStatCard(context, AppLocalizations.of(context)!.profileStatsThisMonth, '${user.stats!.videosCompletedThisMonth}', AppColors.secondary),
                                  const SizedBox(width: 8),
                                  _buildStatCard(context, AppLocalizations.of(context)!.profileStatsLate, '${user.stats!.videosLate}', AppColors.error),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Notifications preferences
                      _buildSection(
                        context,
                        title: AppLocalizations.of(context)!.profileNotifications,
                        icon: Iconsax.notification,
                        child: Column(
                          children: [
                            _buildToggleRow(context, AppLocalizations.of(context)!.profileEmailNotifications, user.emailNotifications ?? false),
                            _buildToggleRow(context, AppLocalizations.of(context)!.profileWhatsappNotifications, user.whatsappNotifications ?? false),
                            _buildInfoRow(context, AppLocalizations.of(context)!.profileWhatsappLinked, user.whatsappLinked == true ? AppLocalizations.of(context)!.commonYes : AppLocalizations.of(context)!.commonNo),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Change password button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const ChangePasswordModal(),
                            );
                          },
                          icon: Icon(Iconsax.lock, size: 18, color: AppColors.primary),
                          label: Text(AppLocalizations.of(context)!.profileChangePassword),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => LoadingIndicator(message: AppLocalizations.of(context)!.loadingProfile),
        error: (error, _) => ErrorDisplay(
          message: AppLocalizations.of(context)!.errorLoadingProfile,
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(fontSize: 13, color: context.textHint)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(BuildContext context, String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13, color: context.textTertiary)),
          ),
          Icon(
            value ? Iconsax.tick_circle : Iconsax.close_circle,
            size: 18,
            color: value ? AppColors.success : context.iconSubtle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: context.textTertiary)),
          ],
        ),
      ),
    );
  }
}
