// lib/widgets/modals/assign_short_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';
import '../../core/models/short.dart';
import '../../core/models/user.dart';
import '../../core/models/admin_channel.dart';
import '../../providers/shorts_provider.dart';
import '../../providers/users_provider.dart';
import '../../providers/channels_provider.dart';

class AssignShortModal extends ConsumerStatefulWidget {
  final Short short;

  const AssignShortModal({super.key, required this.short});

  @override
  ConsumerState<AssignShortModal> createState() => _AssignShortModalState();
}

class _AssignShortModalState extends ConsumerState<AssignShortModal> {
  User? _selectedVideaste;
  AdminChannel? _selectedChannel;
  DateTime? _deadline;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 18, minute: 0),
      );
      if (time != null && mounted) {
        setState(() {
          _deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _assign() async {
    if (_selectedVideaste == null || _selectedChannel == null || _deadline == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(shortsServiceProvider).assignShort(
            shortId: widget.short.id,
            videasteId: _selectedVideaste!.id,
            targetChannelId: _selectedChannel!.id,
            deadline: _deadline!,
            notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          );

      ref.invalidate(shortsStatsProvider);
      ref.invalidate(allShortsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Short assigne avec succes !'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final videastesAsync = ref.watch(videastesProvider);
    final channelsAsync = ref.watch(adminChannelsProvider);

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
                Icon(Iconsax.user_tick, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                const Text('Assigner le short', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
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
                          widget.short.sourceChannel.channelName,
                          style: TextStyle(fontSize: 11, color: AppColors.gray500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Videaste selector
            const Text('Videaste', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            videastesAsync.when(
              data: (videastes) => DropdownButtonFormField<User>(
                initialValue: _selectedVideaste,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Selectionner un videaste',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: videastes.map((v) => DropdownMenuItem(
                  value: v,
                  child: Text(v.username),
                )).toList(),
                onChanged: (v) => setState(() => _selectedVideaste = v),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text('Erreur chargement videastes', style: TextStyle(color: AppColors.error)),
            ),
            const SizedBox(height: 16),

            // Channel selector
            const Text('Chaine de publication', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            channelsAsync.when(
              data: (channels) => DropdownButtonFormField<AdminChannel>(
                initialValue: _selectedChannel,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Selectionner une chaine',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: channels.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text('${c.channelName} (${c.contentType ?? ''})'),
                )).toList(),
                onChanged: (c) => setState(() => _selectedChannel = c),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text('Erreur chargement chaines', style: TextStyle(color: AppColors.error)),
            ),
            const SizedBox(height: 16),

            // Deadline picker
            const Text('Deadline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDeadline,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: context.borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar_1, color: context.iconSubtle, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _deadline != null
                          ? DateFormat('dd/MM/yyyy HH:mm').format(_deadline!)
                          : 'Choisir une date limite',
                      style: TextStyle(
                        color: _deadline != null ? context.textPrimary : context.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            const Text('Notes (optionnel)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Instructions pour le videaste...',
              ),
            ),
            const SizedBox(height: 24),

            // Assign button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_selectedVideaste == null || _selectedChannel == null || _deadline == null || _isLoading)
                    ? null
                    : _assign,
                icon: _isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Iconsax.send_1, size: 18),
                label: const Text('Assigner'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
