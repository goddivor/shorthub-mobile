// lib/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_drawer.dart';
import '../../providers/navigation_provider.dart';
import 'pages/admin_shorts_tracking_page.dart';
import 'pages/admin_rolling_page.dart';
import 'pages/admin_channels_page.dart';
import 'pages/admin_users_page.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _channelsTabIndex = 0; // 0 = Source, 1 = Admin

  String _getCurrentPageTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'Suivi';
      case 1:
        return 'Rolling';
      case 2:
        return 'Canaux';
      case 3:
        return 'Équipe';
      default:
        return 'ShortHub';
    }
  }

  Widget? _getCurrentFAB(int selectedIndex) {
    switch (selectedIndex) {
      case 2: // Page canaux
        if (_channelsTabIndex == 0) {
          // Onglet Source Channels
          return FloatingActionButton(
            onPressed: () {
              AdminChannelsPage.showAddSourceChannelDialog(context, ref);
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Iconsax.add, color: Colors.white),
          );
        } else {
          // Onglet Admin Channels
          return FloatingActionButton(
            onPressed: () {
              AdminChannelsPage.showAddAdminChannelDialog(context, ref);
            },
            backgroundColor: AppColors.success,
            child: const Icon(Iconsax.add, color: Colors.white),
          );
        }
      case 3: // Page utilisateurs
        return FloatingActionButton(
          onPressed: () {
            AdminUsersPage.showInviteDialog(context, ref);
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Iconsax.user_add, color: Colors.white),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);
    final selectedIndex = ref.watch(adminTabIndexProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text('Aucun utilisateur connecté'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            user: user,
            title: _getCurrentPageTitle(selectedIndex),
          ),
          endDrawer: CustomDrawer(user: user),
          body: _buildBody(selectedIndex),
          bottomNavigationBar: _buildBottomNavBar(selectedIndex),
          floatingActionButton: _getCurrentFAB(selectedIndex),
        );
      },
      loading: () => const Scaffold(
        body: LoadingIndicator(message: 'Chargement...'),
      ),
      error: (error, _) => Scaffold(
        body: ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(currentUserProvider);
          },
        ),
      ),
    );
  }


  Widget _buildBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const AdminShortsTrackingPage();
      case 1:
        return const AdminRollingPage();
      case 2:
        return AdminChannelsPage(
          onTabChanged: (index) {
            setState(() {
              _channelsTabIndex = index;
            });
          },
        );
      case 3:
        return const AdminUsersPage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomNavBar(int selectedIndex) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        ref.read(adminTabIndexProvider.notifier).state = index;
        if (index != 2) {
          setState(() => _channelsTabIndex = 0);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray400,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.document_text),
          label: 'Suivi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.video_play),
          label: 'Rolling',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.video_circle),
          label: 'Canaux',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.people),
          label: 'Équipe',
        ),
      ],
    );
  }
}
