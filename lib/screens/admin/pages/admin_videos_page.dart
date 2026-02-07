// lib/screens/admin/pages/admin_videos_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_extensions.dart';
import '../../../providers/shorts_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';

class AdminVideosPage extends ConsumerWidget {
  const AdminVideosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  color: context.iconSubtle,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune vidéo disponible',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.textTertiary,
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
                color: context.cardBg,
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
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          short.sourceChannel.channelName,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textTertiary,
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
                          .withValues(alpha:0.1),
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
}
