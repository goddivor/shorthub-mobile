// ignore_for_file: unnecessary_null_comparison, unused_local_variable

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

  /// Get all channels
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

  /// Get channels with statistics
  static Future<List<Map<String, dynamic>>> getChannelsWithStats() async {
    try {
      // Try to use the view first, fallback to RPC function
      try {
        final response = await client
            .from('channels_with_stats')
            .select();
        return List<Map<String, dynamic>>.from(response);
      } catch (e) {
        // Fallback to RPC function
        final response = await client.rpc('get_channels_with_stats');
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      throw Exception('Failed to get channels with stats: $e');
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

  /// Delete a channel
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

  /// Get database statistics
  static Future<Map<String, int>> getStats() async {
    try {
      // Get total channels
      final channelsResponse = await client
          .from('channels')
          .select('count');

      // Get total shorts rolls
      final shortsResponse = await client
          .from('shorts_rolls')
          .select('count');

      // Get validated shorts
      final validatedResponse = await client
          .from('shorts_rolls')
          .select('count')
          .eq('validated', true);

      return {
        'total_channels': (channelsResponse as List).length,
        'total_shorts': (shortsResponse as List).length,
        'validated_shorts': (validatedResponse as List).length,
      };
    } catch (e) {
      return {
        'total_channels': 0,
        'total_shorts': 0,
        'validated_shorts': 0,
      };
    }
  }

  /// Save a shorts roll
  static Future<void> saveShortRoll({
    required String channelId,
    required String videoUrl,
  }) async {
    try {
      await client.from('shorts_rolls').insert({
        'channel_id': channelId,
        'video_url': videoUrl,
        'validated': false,
      });
    } catch (e) {
      throw Exception('Failed to save short roll: $e');
    }
  }

  /// Validate a shorts roll
  static Future<void> validateShortRoll(String rollId) async {
    try {
      await client
          .from('shorts_rolls')
          .update({'validated': true, 'validated_at': DateTime.now().toIso8601String()})
          .eq('id', rollId);
    } catch (e) {
      throw Exception('Failed to validate short roll: $e');
    }
  }

  /// Get unvalidated shorts for a channel
  static Future<List<Map<String, dynamic>>> getUnvalidatedShorts(String channelId) async {
    try {
      final response = await client
          .from('shorts_rolls')
          .select()
          .eq('channel_id', channelId)
          .eq('validated', false)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get unvalidated shorts: $e');
    }
  }

  /// Check if the tables exist and have the right structure
  static Future<bool> validateSchema() async {
    try {
      // Test channels table
      await client.from('channels').select('id').limit(1);
      
      // Test shorts_rolls table
      await client.from('shorts_rolls').select('id').limit(1);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle realtime subscriptions if needed
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
            }
          },
        )
        .subscribe();
  }
}