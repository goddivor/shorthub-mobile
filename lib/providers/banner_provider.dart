// lib/providers/banner_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../core/services/storage_service.dart';

const _bannerKey = 'banner_image_path';

class BannerNotifier extends StateNotifier<String?> {
  BannerNotifier() : super(null) {
    _load();
  }

  void _load() {
    final path = StorageService.getString(_bannerKey);
    if (path != null && File(path).existsSync()) {
      state = path;
    }
  }

  Future<bool> pickBannerImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (picked == null) return false;

    final dir = await getApplicationDocumentsDirectory();
    final ext = picked.path.split('.').last;
    final dest = '${dir.path}/banner.$ext';

    await File(picked.path).copy(dest);
    await StorageService.setString(_bannerKey, dest);
    state = dest;
    return true;
  }

  Future<void> removeBannerImage() async {
    final path = state;
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    }
    await StorageService.remove(_bannerKey);
    state = null;
  }
}

final bannerProvider = StateNotifierProvider<BannerNotifier, String?>(
  (ref) => BannerNotifier(),
);
