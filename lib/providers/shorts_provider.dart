// lib/providers/shorts_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/short.dart';
import '../core/services/shorts_service.dart';

// Service Provider
final shortsServiceProvider = Provider<ShortsService>((ref) {
  return ShortsService();
});

// All Shorts Provider
final allShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getAllShorts();
});

// Shorts by Status Provider
final shortsByStatusProvider = FutureProvider.family<List<Short>, String>(
  (ref, status) async {
    final service = ref.read(shortsServiceProvider);
    return await service.getShortsByStatus(status);
  },
);

// My Assigned Shorts Provider (for Videaste)
final myAssignedShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getMyAssignedShorts();
});

// Shorts by specific statuses for Videaste Dashboard
final assignedShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getShortsByStatus('ASSIGNED');
});

final inProgressShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getShortsByStatus('IN_PROGRESS');
});

final completedShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getShortsByStatus('COMPLETED');
});

// Shorts for Assistant Dashboard
final pendingValidationShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getShortsByStatus('COMPLETED');
});

final validatedShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getShortsByStatus('VALIDATED');
});

final rejectedShortsProvider = FutureProvider<List<Short>>((ref) async {
  final service = ref.read(shortsServiceProvider);
  return await service.getShortsByStatus('REJECTED');
});

// Shorts Statistics Provider
final shortsStatsProvider = FutureProvider<ShortsStats>((ref) async {
  final service = ref.read(shortsServiceProvider);
  final allShorts = await service.getAllShorts();

  return ShortsStats(
    total: allShorts.length,
    rolled: allShorts.where((s) => s.status == 'ROLLED').length,
    retained: allShorts.where((s) => s.status == 'RETAINED').length,
    assigned: allShorts.where((s) => s.status == 'ASSIGNED').length,
    inProgress: allShorts.where((s) => s.status == 'IN_PROGRESS').length,
    completed: allShorts.where((s) => s.status == 'COMPLETED').length,
    validated: allShorts.where((s) => s.status == 'VALIDATED').length,
    published: allShorts.where((s) => s.status == 'PUBLISHED').length,
    rejected: allShorts.where((s) => s.status == 'REJECTED').length,
  );
});

// Shorts Stats Model
class ShortsStats {
  final int total;
  final int rolled;
  final int retained;
  final int assigned;
  final int inProgress;
  final int completed;
  final int validated;
  final int published;
  final int rejected;

  ShortsStats({
    required this.total,
    required this.rolled,
    required this.retained,
    required this.assigned,
    required this.inProgress,
    required this.completed,
    required this.validated,
    required this.published,
    required this.rejected,
  });
}
