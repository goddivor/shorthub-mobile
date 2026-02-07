// lib/widgets/modals/roll_short_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../core/models/short.dart';
import '../../core/models/source_channel.dart';
import '../../providers/shorts_provider.dart';

class RollShortModal extends ConsumerStatefulWidget {
  final SourceChannel channel;
  final void Function(Short retainedShort) onRetained;

  const RollShortModal({
    super.key,
    required this.channel,
    required this.onRetained,
  });

  @override
  ConsumerState<RollShortModal> createState() => _RollShortModalState();
}

class _RollShortModalState extends ConsumerState<RollShortModal> {
  bool _isLoading = true;
  bool _isActing = false;
  Short? _rolledShort;
  String? _error;

  @override
  void initState() {
    super.initState();
    _rollShort();
  }

  Future<void> _rollShort() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final short = await ref.read(shortsServiceProvider).rollShort(widget.channel.id);
      if (mounted) {
        setState(() {
          _rolledShort = short;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _ignoreShort() async {
    if (_rolledShort == null || _isActing) return;
    setState(() => _isActing = true);

    try {
      await ref.read(shortsServiceProvider).rejectRolledShort(_rolledShort!.id);
      ref.invalidate(shortsStatsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isActing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _retainShort() async {
    if (_rolledShort == null || _isActing) return;
    setState(() => _isActing = true);

    try {
      await ref.read(shortsServiceProvider).retainShort(_rolledShort!.id);
      ref.invalidate(shortsStatsProvider);
      if (mounted) {
        Navigator.pop(context);
        widget.onRetained(_rolledShort!);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isActing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 20),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generation du short...'),
                ],
              ),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Iconsax.warning_2, color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: AppColors.error)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fermer'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _rollShort,
                        child: const Text('Reessayer'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else if (_rolledShort != null)
            _buildShortPreview(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: widget.channel.profileImageUrl != null
              ? NetworkImage(widget.channel.profileImageUrl!)
              : null,
          backgroundColor: context.borderColor,
          child: widget.channel.profileImageUrl == null
              ? Icon(Iconsax.video_circle, color: context.iconSubtle, size: 20)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.channel.channelName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.channel.contentTypeLabel,
                  style: TextStyle(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortPreview() {
    final short = _rolledShort!;
    final thumbnailUrl = 'https://img.youtube.com/vi/${short.videoId}/hqdefault.jpg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: context.borderColor,
                child: Icon(Iconsax.video, color: context.iconSubtle, size: 48),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          short.title ?? short.videoId,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          short.videoUrl,
          style: TextStyle(fontSize: 12, color: context.textHint),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isActing ? null : _ignoreShort,
                icon: Icon(Iconsax.close_circle, size: 18, color: _isActing ? AppColors.gray400 : AppColors.error),
                label: const Text('Ignorer'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: _isActing ? AppColors.gray300 : AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isActing ? null : _retainShort,
                icon: _isActing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Iconsax.tick_circle, size: 18),
                label: const Text('Retenir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
