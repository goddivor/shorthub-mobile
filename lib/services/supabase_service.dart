// ignore_for_file: unnecessary_null_comparison, unused_local_variable, avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/channel_models.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase with credentials
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: false, // Set to true for debugging
    );
  }

  /// Check if the service is properly initialized
  static bool get isInitialized {
    try {
      return Supabase.instance.client != null;
    } catch (e) {
      return false;
    }
  }

  /// Test database connection
  static Future<bool> testConnection() async {
    try {
      final response = await client
          .from('channels')
          .select('count')
          .limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save a new channel to the database
  static Future<Channel> saveChannel(Channel channel) async {
    try {
      // Check if channel already exists
      final existing = await _getChannelByUrl(channel.youtubeUrl);
      if (existing != null) {
        throw Exception('Channel already exists in database');
      }

      final response = await client
          .from('channels')
          .insert(channel.toJson())
          .select()
          .single();

      return Channel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to save channel: $e');
    }
  }

  /// Get channel by YouTube URL
  static Future<Channel?> _getChannelByUrl(String url) async {
    try {
      final response = await client
          .from('channels')
          .select()
          .eq('youtube_url', url)
          .maybeSingle();

      return response != null ? Channel.fromJson(response) : null;
    } catch (e) {
      return null;
    }
  }

  /// Get all channels ordered by creation date (newest first)
  static Future<List<Channel>> getChannels() async {
    try {
      final response = await client
          .from('channels')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channels: $e');
    }
  }

  /// Get channels with search functionality
  static Future<List<Channel>> searchChannels(String query) async {
    try {
      final response = await client
          .from('channels')
          .select()
          .or('username.ilike.%$query%,domain.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search channels: $e');
    }
  }

  /// Get channels filtered by tag
  static Future<List<Channel>> getChannelsByTag(TagType tag) async {
    try {
      final response = await client
          .from('channels')
          .select()
          .eq('tag', tag.value)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channels by tag: $e');
    }
  }

  /// Get channels filtered by type
  static Future<List<Channel>> getChannelsByType(ChannelType type) async {
    try {
      final response = await client
          .from('channels')
          .select()
          .eq('type', type.value)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channels by type: $e');
    }
  }

  /// Update an existing channel
  static Future<Channel> updateChannel(String id, Channel channel) async {
    try {
      final response = await client
          .from('channels')
          .update(channel.toJson())
          .eq('id', id)
          .select()
          .single();

      return Channel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update channel: $e');
    }
  }

  /// Delete a channel by ID
  static Future<void> deleteChannel(String id) async {
    try {
      await client
          .from('channels')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete channel: $e');
    }
  }

  /// Get channel by ID
  static Future<Channel?> getChannelById(String id) async {
    try {
      final response = await client
          .from('channels')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response != null ? Channel.fromJson(response) : null;
    } catch (e) {
      return null;
    }
  }

  /// Get basic statistics
  static Future<Map<String, int>> getBasicStats() async {
    try {
      // Get total channels
      final channelsResponse = await client
          .from('channels')
          .select('count');

      // Get channels by tag
      final vfChannels = await client
          .from('channels')
          .select('count')
          .eq('tag', 'VF');

      final vostfrChannels = await client
          .from('channels')
          .select('count')
          .eq('tag', 'VOSTFR');

      // Get channels by type
      final mixChannels = await client
          .from('channels')
          .select('count')
          .eq('type', 'Mix');

      final onlyChannels = await client
          .from('channels')
          .select('count')
          .eq('type', 'Only');

      return {
        'total_channels': (channelsResponse as List).length,
        'vf_channels': (vfChannels as List).length,
        'vostfr_channels': (vostfrChannels as List).length,
        'mix_channels': (mixChannels as List).length,
        'only_channels': (onlyChannels as List).length,
      };
    } catch (e) {
      return {
        'total_channels': 0,
        'vf_channels': 0,
        'vostfr_channels': 0,
        'mix_channels': 0,
        'only_channels': 0,
      };
    }
  }

  /// Check if the tables exist and have the right structure
  static Future<bool> validateSchema() async {
    try {
      // Test channels table structure
      await client.from('channels').select('id, youtube_url, username, subscriber_count, tag, type, domain, created_at').limit(1);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle realtime subscriptions for channels
  static RealtimeChannel subscribeToChannels({
    required void Function(List<Channel>) onChannelsUpdated,
  }) {
    return client
        .channel('channels_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'channels',
          callback: (payload) async {
            // Refresh channels list when changes occur
            try {
              final channels = await getChannels();
              onChannelsUpdated(channels);
            } catch (e) {
              // Handle error silently or log it
              print('Error refreshing channels: $e');
            }
          },
        )
        .subscribe();
  }

  /// Bulk insert multiple channels (useful for imports)
  static Future<List<Channel>> saveMultipleChannels(List<Channel> channels) async {
    try {
      final response = await client
          .from('channels')
          .insert(channels.map((c) => c.toJson()).toList())
          .select();

      return (response as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to save multiple channels: $e');
    }
  }

  /// Get channels with pagination
  static Future<List<Channel>> getChannelsPaginated({
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      final response = await client
          .from('channels')
          .select()
          .order('created_at', ascending: false)
          .range(start, end);

      return (response as List)
          .map((json) => Channel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get paginated channels: $e');
    }
  }

  /// Count total channels (useful for pagination)
  static Future<int> getChannelsCount() async {
    try {
      final response = await client
          .from('channels')
          .select('count');

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Export all channels data (useful for backup)
  static Future<List<Map<String, dynamic>>> exportChannels() async {
    try {
      final response = await client
          .from('channels')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to export channels: $e');
    }
  }
}