// lib/providers/channels_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/source_channel.dart';
import '../core/models/admin_channel.dart';
import '../core/services/channels_service.dart';

// Service Provider
final channelsServiceProvider = Provider<ChannelsService>((ref) {
  return ChannelsService();
});

// Source Channels Provider
final sourceChannelsProvider = FutureProvider<List<SourceChannel>>((ref) async {
  final service = ref.read(channelsServiceProvider);
  return await service.getSourceChannels();
});

// Admin Channels Provider
final adminChannelsProvider = FutureProvider<List<AdminChannel>>((ref) async {
  final service = ref.read(channelsServiceProvider);
  return await service.getAdminChannels();
});

// Source Channels Count Provider
final sourceChannelsCountProvider = FutureProvider<int>((ref) async {
  final channels = await ref.watch(sourceChannelsProvider.future);
  return channels.length;
});

// Admin Channels Count Provider
final adminChannelsCountProvider = FutureProvider<int>((ref) async {
  final channels = await ref.watch(adminChannelsProvider.future);
  return channels.length;
});
