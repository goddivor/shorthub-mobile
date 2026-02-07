// lib/screens/shared/short_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme/app_colors.dart';
import '../../core/models/short.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/modals/validate_short_modal.dart';
import '../../widgets/modals/reject_short_modal.dart';
import '../../widgets/comments/comment_list.dart';
import '../../widgets/comments/comment_input.dart';

class ShortDetailsScreen extends ConsumerWidget {
  final String shortId;

  const ShortDetailsScreen({super.key, required this.shortId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortAsync = ref.watch(shortByIdProvider(shortId));
    final userAsync = ref.watch(currentUserProvider);
    final userRole = userAsync.valueOrNull?.role ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: shortAsync.when(
        data: (short) => _ShortDetailsBody(short: short, userRole: userRole),
        loading: () => const LoadingIndicator(message: 'Chargement du short...'),
        error: (error, _) => ErrorDisplay(
          message: 'Erreur chargement du short',
          onRetry: () => ref.invalidate(shortByIdProvider(shortId)),
        ),
      ),
    );
  }
}

class _ShortDetailsBody extends ConsumerWidget {
  final Short short;
  final String userRole;

  const _ShortDetailsBody({required this.short, required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = AppColors.getStatusColor(short.status);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return CustomScrollView(
      slivers: [
        // App bar with thumbnail
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: AppColors.gray900,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://img.youtube.com/vi/${short.videoId}/hqdefault.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.gray800,
                    child: Icon(Iconsax.video, color: AppColors.gray400, size: 64),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Iconsax.export_1, color: Colors.white),
              onPressed: () => _openOnYouTube(context),
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + status
                Text(
                  short.title ?? short.videoId,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        short.statusLabel,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
                      ),
                    ),
                    if (short.isLate) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.warning_2, size: 12, color: AppColors.error),
                            const SizedBox(width: 4),
                            Text(
                              'En retard',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),

                // Channels section
                _buildSection(
                  title: 'Chaines',
                  icon: Iconsax.video_circle,
                  child: Column(
                    children: [
                      _buildChannelRow('Source', short.sourceChannel.channelName, short.sourceChannel.profileImageUrl),
                      if (short.targetChannel != null) ...[
                        const SizedBox(height: 10),
                        _buildChannelRow('Publication', short.targetChannel!.channelName, short.targetChannel!.profileImageUrl),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Assignment section
                if (short.assignedTo != null)
                  ...[
                    _buildSection(
                      title: 'Assignation',
                      icon: Iconsax.user_tick,
                      child: Column(
                        children: [
                          _buildInfoRow('Videaste', short.assignedTo!.username),
                          if (short.assignedBy != null)
                            _buildInfoRow('Assigne par', short.assignedBy!.username),
                          if (short.assignedAt != null)
                            _buildInfoRow('Date', dateFormat.format(short.assignedAt!)),
                          if (short.deadline != null)
                            _buildInfoRow(
                              'Deadline',
                              dateFormat.format(short.deadline!),
                              valueColor: short.isLate ? AppColors.error : null,
                            ),
                          if (short.daysUntilDeadline != null)
                            _buildInfoRow(
                              'Jours restants',
                              '${short.daysUntilDeadline}',
                              valueColor: short.daysUntilDeadline! < 0 ? AppColors.error : AppColors.success,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                // Timeline section
                _buildSection(
                  title: 'Historique',
                  icon: Iconsax.timer_1,
                  child: Column(
                    children: [
                      _buildTimelineRow('Rolle', short.rolledAt, AppColors.statusRolled),
                      if (short.retainedAt != null)
                        _buildTimelineRow('Retenu', short.retainedAt!, AppColors.statusRetained),
                      if (short.assignedAt != null)
                        _buildTimelineRow('Assigne', short.assignedAt!, AppColors.statusAssigned),
                      if (short.completedAt != null)
                        _buildTimelineRow('Termine', short.completedAt!, AppColors.statusCompleted),
                      if (short.validatedAt != null)
                        _buildTimelineRow('Valide', short.validatedAt!, AppColors.statusValidated),
                      if (short.publishedAt != null)
                        _buildTimelineRow('Publie', short.publishedAt!, AppColors.statusPublished),
                      if (short.rejectedAt != null)
                        _buildTimelineRow('Rejete', short.rejectedAt!, AppColors.statusRejected),
                      if (short.timeToComplete != null)
                        _buildInfoRow('Temps de completion', '${short.timeToComplete!.toStringAsFixed(1)} heures'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                if (short.notes != null && short.notes!.isNotEmpty) ...[
                  _buildSection(
                    title: 'Notes',
                    icon: Iconsax.note_1,
                    child: Text(short.notes!, style: TextStyle(fontSize: 14, color: AppColors.gray700, height: 1.5)),
                  ),
                  const SizedBox(height: 16),
                ],

                // Admin feedback
                if (short.adminFeedback != null && short.adminFeedback!.isNotEmpty) ...[
                  _buildSection(
                    title: 'Feedback admin',
                    icon: Iconsax.message_text,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: short.isRejected
                            ? AppColors.error.withValues(alpha: 0.05)
                            : AppColors.success.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: short.isRejected
                              ? AppColors.error.withValues(alpha: 0.2)
                              : AppColors.success.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        short.adminFeedback!,
                        style: TextStyle(
                          fontSize: 14,
                          color: short.isRejected ? AppColors.error : AppColors.success,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Drive file info
                if (short.hasFile) ...[
                  _buildSection(
                    title: 'Fichier video',
                    icon: Iconsax.document_upload,
                    child: Column(
                      children: [
                        _buildInfoRow('Nom', short.fileName ?? 'N/A'),
                        if (short.fileSize != null)
                          _buildInfoRow('Taille', _formatFileSize(short.fileSize!)),
                        if (short.mimeType != null)
                          _buildInfoRow('Type', short.mimeType!),
                        if (short.uploadedAt != null)
                          _buildInfoRow('Upload', dateFormat.format(short.uploadedAt!)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Tags
                if (short.tags.isNotEmpty) ...[
                  _buildSection(
                    title: 'Tags',
                    icon: Iconsax.tag,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: short.tags.map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.gray100,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Comments
                _buildSection(
                  title: 'Commentaires (${short.comments.length})',
                  icon: Iconsax.message,
                  child: Column(
                    children: [
                      CommentList(comments: short.comments),
                      const SizedBox(height: 8),
                      CommentInput(
                        onSubmit: (comment) async {
                          await ref.read(shortsServiceProvider).createComment(short.id, comment);
                          ref.invalidate(shortByIdProvider(short.id));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons
                _buildActions(context, ref),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontSize: 13, color: AppColors.gray500)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: valueColor ?? AppColors.gray800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelRow(String label, String name, String? imageUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          backgroundColor: AppColors.gray200,
          child: imageUrl == null ? Icon(Iconsax.video_circle, size: 14, color: AppColors.gray400) : null,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: AppColors.gray400)),
            Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineRow(String label, DateTime date, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
          ),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(date),
            style: TextStyle(fontSize: 12, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final isAdmin = userRole == 'ADMIN';
    final isAssistant = userRole == 'ASSISTANT';
    final isVideaste = userRole == 'VIDEASTE';

    final actions = <Widget>[];

    // Open on YouTube (always)
    actions.add(
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => _openOnYouTube(context),
          icon: Icon(Iconsax.export_1, size: 16, color: AppColors.primary),
          label: const Text('YouTube'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );

    // Validate + Reject (admin/assistant on COMPLETED)
    if ((isAdmin || isAssistant) && short.isCompleted) {
      actions.add(const SizedBox(width: 8));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _openValidateModal(context),
            icon: const Icon(Iconsax.tick_circle, size: 16),
            label: const Text('Valider'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      );
      actions.add(const SizedBox(width: 8));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _openRejectModal(context),
            icon: const Icon(Iconsax.close_circle, size: 16),
            label: const Text('Rejeter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      );
    }

    // Publish (admin on VALIDATED)
    if (isAdmin && short.isValidated) {
      actions.add(const SizedBox(width: 8));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _publishShort(context, ref),
            icon: const Icon(Iconsax.global, size: 16),
            label: const Text('Publier'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      );
    }

    // Start work (videaste on ASSIGNED)
    if (isVideaste && short.isAssigned) {
      actions.add(const SizedBox(width: 8));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _startWork(context, ref),
            icon: const Icon(Iconsax.play, size: 16),
            label: const Text('Travailler'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      );
    }

    // Complete (videaste on IN_PROGRESS)
    if (isVideaste && short.isInProgress) {
      actions.add(const SizedBox(width: 8));
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _completeWork(context, ref),
            icon: const Icon(Iconsax.tick_circle, size: 16),
            label: const Text('Terminer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(children: actions);
  }

  void _openOnYouTube(BuildContext context) async {
    final uri = Uri.parse(short.videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openValidateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ValidateShortModal(short: short),
    );
  }

  void _openRejectModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RejectShortModal(short: short),
    );
  }

  void _publishShort(BuildContext context, WidgetRef ref) {
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
                          ref.invalidate(shortByIdProvider(short.id));
                          if (ctx.mounted) Navigator.pop(ctx);
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

  void _startWork(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) {
        var isLoading = false;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            title: const Text('Commencer le travail'),
            content: const Text('Confirmer le debut du travail sur ce short ?'),
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
                          await ref.read(shortsServiceProvider).startWorkOnShort(short.id);
                          ref.invalidate(shortsStatsProvider);
                          ref.invalidate(allShortsProvider);
                          ref.invalidate(shortByIdProvider(short.id));
                          ref.invalidate(assignedShortsProvider);
                          ref.invalidate(inProgressShortsProvider);
                          if (ctx.mounted) Navigator.pop(ctx);
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Commencer'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _completeWork(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) {
        var isLoading = false;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            title: const Text('Terminer le travail'),
            content: const Text('Confirmer que le travail est termine ?'),
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
                          await ref.read(shortsServiceProvider).completeShort(short.id);
                          ref.invalidate(shortsStatsProvider);
                          ref.invalidate(allShortsProvider);
                          ref.invalidate(shortByIdProvider(short.id));
                          ref.invalidate(inProgressShortsProvider);
                          ref.invalidate(completedShortsProvider);
                          if (ctx.mounted) Navigator.pop(ctx);
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
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Terminer'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
