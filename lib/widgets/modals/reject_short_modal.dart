// lib/widgets/modals/reject_short_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../core/models/short.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/shorts_provider.dart';

class RejectShortModal extends ConsumerStatefulWidget {
  final Short short;

  const RejectShortModal({super.key, required this.short});

  @override
  ConsumerState<RejectShortModal> createState() => _RejectShortModalState();
}

class _RejectShortModalState extends ConsumerState<RejectShortModal> {
  final _reasonController = TextEditingController();
  bool _deleteFile = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _reject() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) return;

    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await ref.read(shortsServiceProvider).updateShortStatus(
            widget.short.id,
            'REJECTED',
            adminFeedback: reason,
            deleteFile: _deleteFile ? true : null,
          );

      ref.invalidate(shortsStatsProvider);
      ref.invalidate(allShortsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.modalRejectSuccess),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.commonErrorPrefix(e.toString())), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Iconsax.close_circle, color: AppColors.error, size: 24),
                const SizedBox(width: 8),
                Text(l10n.modalRejectTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // Short preview
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.chipBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://img.youtube.com/vi/${widget.short.videoId}/default.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: context.borderColor,
                        child: Icon(Iconsax.video, color: context.iconSubtle, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.short.title ?? widget.short.videoId,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.short.assignedTo?.username ?? '',
                          style: TextStyle(fontSize: 11, color: AppColors.gray500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reason (required)
            Text(l10n.modalRejectReason, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.modalRejectReasonHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // Delete file checkbox
            if (widget.short.hasFile)
              CheckboxListTile(
                value: _deleteFile,
                onChanged: (v) => setState(() => _deleteFile = v ?? false),
                title: Text(l10n.modalRejectDeleteFile, style: const TextStyle(fontSize: 13)),
                subtitle: Text(
                  widget.short.fileName ?? l10n.modalRejectDeleteFileDefault,
                  style: TextStyle(fontSize: 11, color: AppColors.gray500),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.error,
              ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.commonCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isLoading || _reasonController.text.trim().isEmpty) ? null : _reject,
                    icon: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Iconsax.close_circle, size: 18),
                    label: Text(l10n.actionReject),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
