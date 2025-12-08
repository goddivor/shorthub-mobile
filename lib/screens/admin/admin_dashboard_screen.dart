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
import 'pages/admin_overview_page.dart';
import 'pages/admin_videos_page.dart';
import 'pages/admin_channels_page.dart';
import 'pages/admin_users_page.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;
  int _channelsTabIndex = 0; // 0 = Source, 1 = Admin

  String _getCurrentPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Aperçu';
      case 1:
        return 'Vidéos';
      case 2:
        return 'Canaux';
      case 3:
        return 'Équipe';
      default:
        return 'ShortHub';
    }
  }

  Widget? _getCurrentFAB() {
    switch (_selectedIndex) {
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
            title: _getCurrentPageTitle(),
          ),
          endDrawer: CustomDrawer(user: user),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavBar(),
          floatingActionButton: _getCurrentFAB(),
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


  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const AdminOverviewPage();
      case 1:
        return const AdminVideosPage();
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          // Réinitialiser l'index de l'onglet quand on change de page
          if (index != 2) {
            _channelsTabIndex = 0;
          }
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.gray400,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: 'Aperçu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.video),
          label: 'Vidéos',
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
