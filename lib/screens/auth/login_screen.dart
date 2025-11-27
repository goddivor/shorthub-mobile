// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      await ref.read(currentUserProvider.notifier).login(username, password);

      if (!mounted) return;

      // Get the logged in user
      final userState = ref.read(currentUserProvider);

      userState.when(
        data: (user) {
          if (user != null && user.role != null) {
            // Navigate based on role using named routes
            final route = AppRouter.getDashboardRoute(user.role!);
            Navigator.of(context).pushReplacementNamed(route);
          }
        },
        loading: () {},
        error: (error, _) {
          setState(() {
            _errorMessage = error.toString();
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion. Vérifiez vos identifiants.';
        _isLoading = false;
      });
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom d\'utilisateur est requis';
    }
    if (value.length < 3) {
      return 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.video_square,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'ShortHub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestion collaborative de YouTube Shorts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.danger,
                            size: 20,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Username Field
                  CustomTextField(
                    label: 'Nom d\'utilisateur',
                    hint: 'Entrez votre nom d\'utilisateur',
                    controller: _usernameController,
                    validator: _validateUsername,
                    prefixIcon: Icon(
                      Iconsax.user,
                      color: AppColors.gray400,
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    label: 'Mot de passe',
                    hint: 'Entrez votre mot de passe',
                    controller: _passwordController,
                    obscureText: true,
                    validator: _validatePassword,
                    prefixIcon: Icon(
                      Iconsax.lock,
                      color: AppColors.gray400,
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  CustomButton(
                    text: 'Se connecter',
                    onPressed: _isLoading ? null : _handleLogin,
                    isLoading: _isLoading,
                    icon: Iconsax.login,
                  ),

                  const SizedBox(height: 24),

                  // App Version
                  Text(
                    'Version 2.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
