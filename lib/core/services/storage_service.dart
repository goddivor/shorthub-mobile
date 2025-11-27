// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../../config/constants.dart';

/// Service for local storage operations
class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize storage
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  // ==================== Auth Tokens ====================

  /// Save auth token
  static Future<bool> setAuthToken(String token) async {
    return await _instance.setString(AppConstants.authTokenKey, token);
  }

  /// Get auth token
  static Future<String?> getAuthToken() async {
    return _instance.getString(AppConstants.authTokenKey);
  }

  /// Save refresh token
  static Future<bool> setRefreshToken(String token) async {
    return await _instance.setString(AppConstants.refreshTokenKey, token);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return _instance.getString(AppConstants.refreshTokenKey);
  }

  /// Clear all auth tokens
  static Future<bool> clearAuthTokens() async {
    await _instance.remove(AppConstants.authTokenKey);
    await _instance.remove(AppConstants.refreshTokenKey);
    await _instance.remove(AppConstants.userDataKey);
    return true;
  }

  // ==================== User Data ====================

  /// Save user data
  static Future<bool> setUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    return await _instance.setString(AppConstants.userDataKey, userJson);
  }

  /// Get user data
  static Future<User?> getUser() async {
    final userJson = _instance.getString(AppConstants.userDataKey);
    if (userJson == null) return null;

    try {
      final userData = jsonDecode(userJson);
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== Theme ====================

  /// Save theme mode
  static Future<bool> setThemeMode(String mode) async {
    return await _instance.setString(AppConstants.themeModeKey, mode);
  }

  /// Get theme mode
  static String? getThemeMode() {
    return _instance.getString(AppConstants.themeModeKey);
  }

  // ==================== Generic Methods ====================

  /// Save string value
  static Future<bool> setString(String key, String value) async {
    return await _instance.setString(key, value);
  }

  /// Get string value
  static String? getString(String key) {
    return _instance.getString(key);
  }

  /// Save int value
  static Future<bool> setInt(String key, int value) async {
    return await _instance.setInt(key, value);
  }

  /// Get int value
  static int? getInt(String key) {
    return _instance.getInt(key);
  }

  /// Save bool value
  static Future<bool> setBool(String key, bool value) async {
    return await _instance.setBool(key, value);
  }

  /// Get bool value
  static bool? getBool(String key) {
    return _instance.getBool(key);
  }

  /// Remove value
  static Future<bool> remove(String key) async {
    return await _instance.remove(key);
  }

  /// Clear all data
  static Future<bool> clearAll() async {
    return await _instance.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return _instance.containsKey(key);
  }
}
