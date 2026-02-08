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
import '../../../l10n/app_localizations.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  // Methode statique pour afficher le dialog d'invitation
  static void showInviteDialog(BuildContext context, WidgetRef ref) {
    _AdminUsersPageState._showInviteUserDialog(context, ref);
  }

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  String _searchQuery = '';
  String _roleFilter = 'ALL';

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
    final l10n = AppLocalizations.of(context)!;

    final roleOptions = [
      {'value': 'ALL', 'label': l10n.usersAllRoles},
      {'value': 'ADMIN', 'label': l10n.roleAdmin},
      {'value': 'VIDEASTE', 'label': l10n.roleVideaste},
      {'value': 'ASSISTANT', 'label': l10n.roleAssistant},
    ];

    return Column(
      children: [
        SearchFilterBar(
          hintText: l10n.usersSearchHint,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          filterValue: _roleFilter,
          filterOptions: roleOptions,
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
                                      ? l10n.usersEmpty
                                      : l10n.usersNoUsers,
                                  style: TextStyle(fontSize: 16, color: AppColors.gray600),
                                ),
                                if (_searchQuery.isEmpty && _roleFilter == 'ALL') ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.usersInviteHint,
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
                                  content: Text(l10n.userViewProfile),
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
            loading: () => LoadingIndicator(message: l10n.usersLoading),
            error: (error, _) => ErrorDisplay(
              message: l10n.usersLoadingError,
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
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Row(
              children: [
                Icon(Iconsax.user_add, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(l10n.usersInviteTitle),
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
                    decoration: InputDecoration(
                      labelText: l10n.usersUsername,
                      hintText: l10n.usersUsernameHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.user),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.usersEmailOptional,
                      hintText: l10n.usersEmailHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.sms),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.usersPassword,
                      hintText: l10n.usersPasswordHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.lock),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Role
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    decoration: InputDecoration(
                      labelText: l10n.usersRole,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Iconsax.shield_tick),
                    ),
                    items: [
                      DropdownMenuItem(value: 'VIDEASTE', child: Text(l10n.roleVideaste)),
                      DropdownMenuItem(value: 'ASSISTANT', child: Text(l10n.roleAssistant)),
                      DropdownMenuItem(value: 'ADMIN', child: Text(l10n.roleAdmin)),
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
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        // Validation
                        if (usernameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.usersUsernameRequired),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        if (passwordController.text.trim().length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.usersPasswordMinLength),
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
                                content: Text(l10n.usersCreatedSuccess(usernameController.text)),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.commonErrorPrefix(e.toString())),
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
                    : Text(l10n.usersInviteButton),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showBlockUserDialog(BuildContext context, WidgetRef ref, User user) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.usersBlockButton),
          content: Text(l10n.usersBlockConfirm(user.username)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
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
                        content: Text(l10n.usersBlocked(user.username)),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.commonErrorPrefix(e.toString())),
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
              child: Text(l10n.usersBlockButton),
            ),
          ],
        );
      },
    );
  }

  static void _showUnblockUserDialog(BuildContext context, WidgetRef ref, User user) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.usersUnblockButton),
          content: Text(l10n.usersUnblockConfirm(user.username)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonCancel),
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
                        content: Text(l10n.usersUnblocked(user.username)),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.commonErrorPrefix(e.toString())),
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
              child: Text(l10n.usersUnblockButton),
            ),
          ],
        );
      },
    );
  }

  static void _showDeleteUserDialog(BuildContext context, WidgetRef ref, User user) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Iconsax.warning_2, color: AppColors.error),
              const SizedBox(width: 12),
              Text(l10n.usersDeleteButton),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.usersDeleteConfirm(user.username)),
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
                    Expanded(
                      child: Text(
                        l10n.usersIrreversible,
                        style: const TextStyle(
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
              child: Text(l10n.commonCancel),
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
                        content: Text(l10n.usersDeleted(user.username)),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.commonErrorPrefix(e.toString())),
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
              child: Text(l10n.usersDeleteButton),
            ),
          ],
        );
      },
    );
  }
}
