// lib/providers/navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin dashboard bottom nav tab index (0=Suivi, 1=Rolling, 2=Canaux, 3=Equipe)
final adminTabIndexProvider = StateProvider<int>((ref) => 0);

/// Videaste dashboard tab index (0=Assignees, 1=En cours, 2=Terminees)
final videasteTabIndexProvider = StateProvider<int>((ref) => 0);

/// Assistant dashboard tab index (0=A valider, 1=Validees, 2=Rejetees)
final assistantTabIndexProvider = StateProvider<int>((ref) => 0);
