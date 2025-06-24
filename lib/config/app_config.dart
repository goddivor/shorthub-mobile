// lib/config/app_config.dart
class AppConfig {
  // YouTube API configuration
  static const String youtubeApiKey = String.fromEnvironment(
    'YOUTUBE_API_KEY',
    defaultValue: '', // Will be empty if not provided
  );

  // Supabase configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '', // Will be empty if not provided
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '', // Will be empty if not provided
  );

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

/* 
HOW TO SET UP ENVIRONMENT VARIABLES:

1. For development in VS Code:
   Create a launch.json file in .vscode/ folder:
   
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Flutter Development",
         "request": "launch",
         "type": "dart",
         "toolArgs": [
           "--dart-define=YOUTUBE_API_KEY=your_actual_youtube_api_key",
           "--dart-define=SUPABASE_URL=https://your-project.supabase.co",
           "--dart-define=SUPABASE_ANON_KEY=your_actual_supabase_anon_key"
         ]
       }
     ]
   }

2. For command line development:
   flutter run --dart-define=YOUTUBE_API_KEY=AIzaSyBnf-n5QazXBC4oagloFOcQJKx9TBiOsXg --dart-define=SUPABASE_URL=https://vyuklqwnfsvqmobmslwv.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5dWtscXduZnN2cW1vYm1zbHd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3ODQ3NzIsImV4cCI6MjA2NTM2MDc3Mn0.626lxcRHwBFUh34y9CfZx9X7EQp6T47gDtoSHwUd0hY
  
3. For production builds:
   Add to android/gradle.properties:
   YOUTUBE_API_KEY=your_key
   SUPABASE_URL=your_url
   SUPABASE_ANON_KEY=your_key
   
   Then modify android/app/build.gradle:
   buildConfigField "String", "YOUTUBE_API_KEY", "\"${project.findProperty('YOUTUBE_API_KEY') ?: ''}\""

4. Create a .env file (add to .gitignore):
   YOUTUBE_API_KEY=your_actual_key_here
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your_actual_key_here
*/
