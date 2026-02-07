// lib/screens/admin/pages/admin_users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../providers/users_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../widgets/cards/user_card.dart';
import '../../../core/models/user.dart';
import '../../../widgets/common/search_filter_bar.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  // Méthode statique pour afficher le dialog d'invitation
  static void showInviteDialog(BuildContext context, WidgetRef ref) {
    _AdminUsersPageState._showInviteUserDialog(context, ref);
  }

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  String _searchQuery = '';
  String _roleFilter = 'ALL';

  static const _roleOptions = [
    {'value': 'ALL', 'label': 'Tous les roles'},
    {'value': 'ADMIN', 'label': 'Admin'},
    {'value': 'VIDEASTE', 'label': 'Videaste'},
    {'value': 'ASSISTANT', 'label': 'Assistant'},
  ];

  List<User> _filterUsers(List<User> users) {
    return users.where((u) {
      if (_roleFilter != 'ALL' && u.role != _roleFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!u.username.toLowerCase().contains(query) &&
            !(u.email ?? '').toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return Column(
      children: [
        SearchFilterBar(
          hintText: 'Rechercher un membre...',
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          filterValue: _roleFilter,
          filterOptions: _roleOptions,
          onFilterChanged: (v) => setState(() => _roleFilter = v ?? 'ALL'),
        ),
        Expanded(
          child: usersAsync.when(
            data: (allUsers) {
              final users = _filterUsers(allUsers);

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(allUsersProvider),
                child: users.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Iconsax.people, size: 64, color: AppColors.gray300),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty || _roleFilter != 'ALL'
                                      ? 'Aucun membre trouve'
                                      : 'Aucun utilisateur',
                                  style: TextStyle(fontSize: 16, color: AppColors.gray600),
                                ),
                                if (_searchQuery.isEmpty && _roleFilter == 'ALL') ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Commencez par inviter des membres',
                                    style: TextStyle(fontSize: 14, color: AppColors.gray500),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserCard(
                            user: user,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Profil de ${user.username}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            onBlock: () {
                              _showBlockUserDialog(context, ref, user);
                            },
                            onUnblock: () {
                              _showUnblockUserDialog(context, ref, user);
                            },
                            onDelete: () {
                              _showDeleteUserDialog(context, ref, user);
                            },
                          );
                        },
                      ),
              );
            },
            loading: () => const LoadingIndicator(message: 'Chargement des utilisateurs...'),
            error: (error, _) => ErrorDisplay(
              message: 'Erreur lors du chargement des utilisateurs',
              onRetry: () => ref.invalidate(allUsersProvider),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== User Management Dialogs ====================

  static void _showInviteUserDialog(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'VIDEASTE';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Iconsax.user_add, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text('Inviter un utilisateur'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    hintText: 'Ex: johndoe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (optionnel)',
                    hintText: 'exemple@email.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.sms),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Minimum 6 caractères',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.lock),
                  ),
                ),
                const SizedBox(height: 16),

                // Role
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.shield_tick),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'VIDEASTE', child: Text('Vidéaste')),
                    DropdownMenuItem(value: 'ASSISTANT', child: Text('Assistant')),
                    DropdownMenuItem(value: 'ADMIN', child: Text('Administrateur')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedRole = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      // Validation
                      if (usernameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Le nom d\'utilisateur est requis'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      if (passwordController.text.trim().length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Le mot de passe doit contenir au moins 6 caractères'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        final service = ref.read(usersServiceProvider);
                        await service.createUser(
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                          email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                          role: selectedRole,
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ref.invalidate(allUsersProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Utilisateur ${usernameController.text} créé avec succès'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erreur: ${e.toString()}'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      } finally {
                        if (context.mounted) {
                          setState(() => isLoading = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Inviter'),
            ),
          ],
        ),
      ),
    );
  }

  static void _showBlockUserDialog(BuildContext context, WidgetRef ref, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bloquer l\'utilisateur'),
        content: Text('Êtes-vous sûr de vouloir bloquer ${user.username} ? Il ne pourra plus accéder à l\'application.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final service = ref.read(usersServiceProvider);
                await service.updateUserStatus(user.id, 'BLOCKED');

                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(allUsersProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${user.username} a été bloqué'),
                      backgroundColor: AppColors.warning,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            child: const Text('Bloquer'),
          ),
        ],
      ),
    );
  }

  static void _showUnblockUserDialog(BuildContext context, WidgetRef ref, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Débloquer l\'utilisateur'),
        content: Text('Êtes-vous sûr de vouloir débloquer ${user.username} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final service = ref.read(usersServiceProvider);
                await service.updateUserStatus(user.id, 'ACTIVE');

                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(allUsersProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${user.username} a été débloqué'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Débloquer'),
          ),
        ],
      ),
    );
  }

  static void _showDeleteUserDialog(BuildContext context, WidgetRef ref, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.warning_2, color: AppColors.error),
            const SizedBox(width: 12),
            const Text('Supprimer l\'utilisateur'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Êtes-vous sûr de vouloir supprimer ${user.username} ?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Cette action est irréversible',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final service = ref.read(usersServiceProvider);
                await service.deleteUser(user.id);

                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(allUsersProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${user.username} a été supprimé'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
