// lib/widgets/cards/short_tracking_card.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../core/models/short.dart';

class ShortTrackingCard extends StatelessWidget {
  final Short short;
  final VoidCallback? onView;
  final VoidCallback? onValidate;
  final VoidCallback? onReject;
  final VoidCallback? onPublish;

  const ShortTrackingCard({
    super.key,
    required this.short,
    this.onView,
    this.onValidate,
    this.onReject,
    this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.getStatusColor(short.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: short.isLate
            ? Border.all(color: AppColors.error.withValues(alpha: 0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://img.youtube.com/vi/${short.videoId}/mqdefault.jpg',
                    width: 80,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 60,
                      color: AppColors.gray200,
                      child: Icon(Iconsax.video, color: AppColors.gray400, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        short.title ?? short.videoId,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Channels
                      Row(
                        children: [
                          Icon(Iconsax.video_circle, size: 12, color: AppColors.gray400),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              short.sourceChannel.channelName,
                              style: TextStyle(fontSize: 11, color: AppColors.gray500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (short.targetChannel != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Iconsax.arrow_right_3, size: 10, color: AppColors.gray400),
                            ),
                            Flexible(
                              child: Text(
                                short.targetChannel!.channelName,
                                style: TextStyle(fontSize: 11, color: AppColors.secondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Status badge + late indicator
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              short.statusLabel,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                            ),
                          ),
                          if (short.isLate) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Iconsax.warning_2, size: 10, color: AppColors.error),
                                  const SizedBox(width: 3),
                                  Text(
                                    'En retard',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.error),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Meta info row (videaste + deadline)
          if (short.assignedTo != null || short.deadline != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (short.assignedTo != null) ...[
                    Icon(Iconsax.user, size: 12, color: AppColors.gray400),
                    const SizedBox(width: 4),
                    Text(
                      short.assignedTo!.username,
                      style: TextStyle(fontSize: 11, color: AppColors.gray600),
                    ),
                  ],
                  if (short.assignedTo != null && short.deadline != null)
                    const SizedBox(width: 12),
                  if (short.deadline != null) ...[
                    Icon(
                      Iconsax.calendar_1,
                      size: 12,
                      color: short.isLate ? AppColors.error : AppColors.gray400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(short.deadline!),
                      style: TextStyle(
                        fontSize: 11,
                        color: short.isLate ? AppColors.error : AppColors.gray600,
                        fontWeight: short.isLate ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                  if (short.hasFile) ...[
                    const Spacer(),
                    Icon(Iconsax.document_upload, size: 12, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'Fichier',
                      style: TextStyle(fontSize: 11, color: AppColors.success),
                    ),
                  ],
                ],
              ),
            ),

          // Notes
          if (short.notes != null && short.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.note_1, size: 12, color: AppColors.gray400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        short.notes!,
                        style: TextStyle(fontSize: 11, color: AppColors.gray600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Admin feedback
          if (short.adminFeedback != null && short.adminFeedback!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: short.isRejected
                      ? AppColors.error.withValues(alpha: 0.05)
                      : AppColors.success.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: short.isRejected
                        ? AppColors.error.withValues(alpha: 0.2)
                        : AppColors.success.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      short.isRejected ? Iconsax.close_circle : Iconsax.tick_circle,
                      size: 12,
                      color: short.isRejected ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        short.adminFeedback!,
                        style: TextStyle(
                          fontSize: 11,
                          color: short.isRejected ? AppColors.error : AppColors.success,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // View button (always)
                _buildActionButton(
                  label: 'Voir',
                  icon: Iconsax.eye,
                  color: AppColors.gray600,
                  onTap: onView,
                ),
                // Validate + Reject (COMPLETED only)
                if (short.isCompleted) ...[
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: 'Valider',
                    icon: Iconsax.tick_circle,
                    color: AppColors.success,
                    onTap: onValidate,
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: 'Rejeter',
                    icon: Iconsax.close_circle,
                    color: AppColors.error,
                    onTap: onReject,
                  ),
                ],
                // Publish (VALIDATED only)
                if (short.isValidated) ...[
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: 'Publier',
                    icon: Iconsax.global,
                    color: Colors.deepPurple,
                    onTap: onPublish,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
