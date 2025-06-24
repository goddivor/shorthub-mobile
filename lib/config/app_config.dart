import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // YouTube API configuration
  static String get youtubeApiKey => dotenv.env['YOUTUBE_API_KEY'] ?? '';

  // Supabase configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Validation methods
  static bool get isYouTubeConfigured => youtubeApiKey.isNotEmpty;
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  static bool get isFullyConfigured =>
      isYouTubeConfigured && isSupabaseConfigured;

  // Debug info
  static Map<String, dynamic> get debugInfo => {
        'youtube_configured': isYouTubeConfigured,
        'supabase_configured': isSupabaseConfigured,
        'fully_configured': isFullyConfigured,
        'youtube_key_length': youtubeApiKey.length,
        'supabase_url_length': supabaseUrl.length,
        'supabase_key_length': supabaseAnonKey.length,
      };
}