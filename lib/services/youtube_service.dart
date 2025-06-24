import 'package:dio/dio.dart';
import '../models/channel_models.dart';

class YouTubeService {
  final Dio _dio;
  final String? _apiKey;

  YouTubeService({String? apiKey})
      : _apiKey = apiKey,
        _dio = Dio(BaseOptions(
          baseUrl: 'https://www.googleapis.com/youtube/v3',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  /// Extract channel data from any YouTube URL
  Future<YouTubeChannelData> extractChannelData(String url) async {
    try {
      final channelId = await _getChannelIdFromUrl(url);
      return await _getChannelDetails(channelId);
    } catch (e) {
      throw Exception('Failed to extract channel data: $e');
    }
  }

  /// Get channel ID from various YouTube URL formats
  Future<String> _getChannelIdFromUrl(String url) async {
    final uri = Uri.parse(url);
    
    // Direct channel ID URLs
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'channel') {
      return uri.pathSegments[1];
    }
    
    // Handle @username format
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0].startsWith('@')) {
      return await _searchChannelByHandle(uri.pathSegments[0]);
    }
    
    // Handle /c/ custom URLs
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'c') {
      return await _searchChannelByCustomUrl(uri.pathSegments[1]);
    }
    
    // Handle /user/ URLs
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'user') {
      return await _searchChannelByUsername(uri.pathSegments[1]);
    }
    
    // Handle video URLs - extract channel from video
    if (uri.pathSegments.isNotEmpty && 
        (uri.pathSegments[0] == 'watch' || uri.pathSegments[0] == 'shorts')) {
      final videoId = _extractVideoId(url);
      return await _getChannelIdFromVideo(videoId);
    }
    
    // Handle youtu.be short URLs
    if (uri.host == 'youtu.be') {
      final videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
      return await _getChannelIdFromVideo(videoId);
    }
    
    throw Exception('Unsupported YouTube URL format');
  }

  /// Extract video ID from various YouTube URL formats
  String _extractVideoId(String url) {
    final uri = Uri.parse(url);
    
    // Standard watch URLs
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    
    // Shorts URLs
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'shorts') {
      return uri.pathSegments[1];
    }
    
    // youtu.be URLs
    if (uri.host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments[0];
    }
    
    throw Exception('Could not extract video ID from URL');
  }

  /// Get channel ID from video ID
  Future<String> _getChannelIdFromVideo(String videoId) async {
    if (_apiKey == null) {
      throw Exception('YouTube API key not configured');
    }

    try {
      final response = await _dio.get('/videos', queryParameters: {
        'part': 'snippet',
        'id': videoId,
        'key': _apiKey,
      });

      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List?;
      
      if (items == null || items.isEmpty) {
        throw Exception('Video not found');
      }

      final snippet = items[0]['snippet'] as Map<String, dynamic>;
      return snippet['channelId'] as String;
    } catch (e) {
      throw Exception('Failed to get channel ID from video: $e');
    }
  }

  /// Search for channel by handle (@username)
  Future<String> _searchChannelByHandle(String handle) async {
    return await _searchChannelByQuery(handle.replaceFirst('@', ''));
  }

  /// Search for channel by custom URL
  Future<String> _searchChannelByCustomUrl(String customUrl) async {
    return await _searchChannelByQuery(customUrl);
  }

  /// Search for channel by username
  Future<String> _searchChannelByUsername(String username) async {
    return await _searchChannelByQuery(username);
  }

  /// Search for channel using the search API
  Future<String> _searchChannelByQuery(String query) async {
    if (_apiKey == null) {
      throw Exception('YouTube API key not configured');
    }

    try {
      final response = await _dio.get('/search', queryParameters: {
        'part': 'snippet',
        'type': 'channel',
        'q': query,
        'maxResults': 1,
        'key': _apiKey,
      });

      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List?;
      
      if (items == null || items.isEmpty) {
        throw Exception('Channel not found');
      }

      final snippet = items[0]['snippet'] as Map<String, dynamic>;
      return snippet['channelId'] as String;
    } catch (e) {
      throw Exception('Failed to search for channel: $e');
    }
  }

  /// Get detailed channel information
  Future<YouTubeChannelData> _getChannelDetails(String channelId) async {
    if (_apiKey == null) {
      throw Exception('YouTube API key not configured');
    }

    try {
      final response = await _dio.get('/channels', queryParameters: {
        'part': 'snippet,statistics',
        'id': channelId,
        'key': _apiKey,
      });

      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List?;
      
      if (items == null || items.isEmpty) {
        throw Exception('Channel not found');
      }

      final channel = items[0] as Map<String, dynamic>;
      final snippet = channel['snippet'] as Map<String, dynamic>;
      final statistics = channel['statistics'] as Map<String, dynamic>;

      // Extract username from custom URL or use title
      String username = snippet['title'] as String;
      if (snippet['customUrl'] != null) {
        final customUrl = snippet['customUrl'] as String;
        username = customUrl.startsWith('@') ? customUrl : '@$customUrl';
      }

      final subscriberCount = int.tryParse(
        statistics['subscriberCount'] as String? ?? '0'
      ) ?? 0;

      return YouTubeChannelData(
        username: username,
        subscriberCount: subscriberCount,
        thumbnailUrl: snippet['thumbnails']?['high']?['url'] as String?,
        description: snippet['description'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to get channel details: $e');
    }
  }

  /// Check if URL is a valid YouTube URL
  static bool isValidYouTubeUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final validHosts = [
        'youtube.com',
        'www.youtube.com',
        'm.youtube.com',
        'youtu.be',
      ];
      
      return validHosts.contains(uri.host.toLowerCase());
    } catch (e) {
      return false;
    }
  }

  /// Normalize YouTube URL to standard format
  static String normalizeYouTubeUrl(String url) {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    
    try {
      final uri = Uri.parse(url);
      
      // Convert youtu.be to youtube.com
      if (uri.host == 'youtu.be') {
        final videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
        return 'https://www.youtube.com/watch?v=$videoId';
      }
      
      // Ensure www prefix
      if (uri.host == 'youtube.com' || uri.host == 'm.youtube.com') {
        return url.replaceFirst(uri.host, 'www.youtube.com');
      }
      
      return url;
    } catch (e) {
      return url;
    }
  }

  /// Format subscriber count for display
  static String formatSubscriberCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}