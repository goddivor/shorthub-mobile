// lib/providers/users_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/user.dart';
import '../core/services/users_service.dart';

// Service Provider
final usersServiceProvider = Provider<UsersService>((ref) {
  return UsersService();
});

// All Users Provider
final allUsersProvider = FutureProvider<List<User>>((ref) async {
  final service = ref.read(usersServiceProvider);
  return await service.getAllUsers();
});

// Users by Role Provider
final usersByRoleProvider = FutureProvider.family<List<User>, String>(
  (ref, role) async {
    final service = ref.read(usersServiceProvider);
    return await service.getUsersByRole(role);
  },
);

// Videastes Provider
final videastesProvider = FutureProvider<List<User>>((ref) async {
  final service = ref.read(usersServiceProvider);
  return await service.getVideastes();
});

// Assistants Provider
final assistantsProvider = FutureProvider<List<User>>((ref) async {
  final service = ref.read(usersServiceProvider);
  return await service.getAssistants();
});

// Users Count Provider
final usersCountProvider = FutureProvider<int>((ref) async {
  final users = await ref.watch(allUsersProvider.future);
  return users.length;
});

// Users Stats Provider
final usersStatsProvider = FutureProvider<UsersStats>((ref) async {
  final users = await ref.watch(allUsersProvider.future);

  return UsersStats(
    total: users.length,
    admins: users.where((u) => u.role == 'ADMIN').length,
    videastes: users.where((u) => u.role == 'VIDEASTE').length,
    assistants: users.where((u) => u.role == 'ASSISTANT').length,
    active: users.where((u) => u.status == 'ACTIVE').length,
    inactive: users.where((u) => u.status == 'INACTIVE').length,
  );
});

// Users Stats Model
class UsersStats {
  final int total;
  final int admins;
  final int videastes;
  final int assistants;
  final int active;
  final int inactive;

  UsersStats({
    required this.total,
    required this.admins,
    required this.videastes,
    required this.assistants,
    required this.active,
    required this.inactive,
  });
}
