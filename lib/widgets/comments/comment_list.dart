// lib/widgets/comments/comment_list.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../core/models/short_comment.dart';

class CommentList extends StatelessWidget {
  final List<ShortComment> comments;

  const CommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            children: [
              Icon(Iconsax.message, size: 32, color: AppColors.gray300),
              const SizedBox(height: 8),
              Text(
                'Aucun commentaire',
                style: TextStyle(fontSize: 13, color: AppColors.gray400),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: comments.map((c) => _CommentTile(comment: c)).toList(),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final ShortComment comment;

  const _CommentTile({required this.comment});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} mois';
    if (diff.inDays > 0) return '${diff.inDays}j';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}min';
    return 'maintenant';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: comment.author.profileImage != null &&
                    comment.author.profileImage!.isNotEmpty
                ? NetworkImage(comment.author.profileImage!)
                : null,
            child: comment.author.profileImage == null ||
                    comment.author.profileImage!.isEmpty
                ? Text(
                    comment.author.username.isNotEmpty
                        ? comment.author.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.author.username,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeAgo(comment.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.gray700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
