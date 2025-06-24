import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../models/channel_models.dart';
import '../services/youtube_service.dart';
import '../services/supabase_service.dart';
import '../config/app_config.dart';

// YouTube service provider
final youtubeServiceProvider = Provider<YouTubeService>((ref) {
  return YouTubeService(
    apiKey: AppConfig.youtubeApiKey.isEmpty ? null : AppConfig.youtubeApiKey,
  );
});

// Shared URL state - what URL was shared to our app
final sharedUrlProvider =
    StateNotifierProvider<SharedUrlNotifier, String?>((ref) {
  return SharedUrlNotifier();
});

class SharedUrlNotifier extends StateNotifier<String?> {
  SharedUrlNotifier() : super(null);

  void setUrl(String url) {
    state = url;
  }

  void clear() {
    state = null;
  }
}

// Share intent data provider - handles YouTube data extraction
final shareIntentProvider =
    StateNotifierProvider<ShareIntentNotifier, ShareIntentData?>((ref) {
  return ShareIntentNotifier(ref.read(youtubeServiceProvider));
});

class ShareIntentNotifier extends StateNotifier<ShareIntentData?> {
  final YouTubeService _youtubeService;

  ShareIntentNotifier(this._youtubeService) : super(null);

  Future<void> processSharedUrl(String url) async {
    if (!YouTubeService.isValidYouTubeUrl(url)) {
      state = ShareIntentData(
        originalUrl: url,
        error: 'Invalid YouTube URL',
      );
      return;
    }

    // Set loading state
    state = ShareIntentData(
      originalUrl: url,
      isLoading: true,
    );

    try {
      final normalizedUrl = YouTubeService.normalizeYouTubeUrl(url);
      final channelData =
          await _youtubeService.extractChannelData(normalizedUrl);

      state = ShareIntentData(
        originalUrl: url,
        extractedChannelUrl: normalizedUrl,
        channelData: channelData,
        isLoading: false,
      );
    } catch (e) {
      state = ShareIntentData(
        originalUrl: url,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = null;
  }
}

// Form data provider - handles user selections in the overlay
final channelFormProvider =
    StateNotifierProvider<ChannelFormNotifier, ChannelFormData>((ref) {
  return ChannelFormNotifier();
});

class ChannelFormNotifier extends StateNotifier<ChannelFormData> {
  ChannelFormNotifier() : super(const ChannelFormData());

  void setTag(TagType tag) {
    state = state.copyWith(selectedTag: tag);
  }

  void setType(ChannelType type) {
    state = state.copyWith(selectedType: type);

    // Clear category if switching to Mix type
    if (type == ChannelType.mix) {
      state = state.copyWith(selectedCategory: null);
    }
  }

  void setCategory(ContentCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void reset() {
    state = const ChannelFormData();
  }
}

// Channel save provider - handles saving to Supabase
final channelSaveProvider =
    StateNotifierProvider<ChannelSaveNotifier, AsyncValue<void>>((ref) {
  return ChannelSaveNotifier();
});

class ChannelSaveNotifier extends StateNotifier<AsyncValue<void>> {
  ChannelSaveNotifier() : super(const AsyncValue.data(null));

  Future<void> saveChannel({
    required ShareIntentData shareData,
    required ChannelFormData formData,
  }) async {
    if (shareData.channelData == null || !formData.isValid) {
      state = AsyncValue.error(
        'Invalid data - cannot save channel',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final channel = Channel(
        youtubeUrl: shareData.extractedChannelUrl ?? shareData.originalUrl,
        username: shareData.channelData!.username,
        subscriberCount: shareData.channelData!.subscriberCount,
        tag: formData.selectedTag!,
        type: formData.selectedType!,
        domain: formData.selectedType == ChannelType.only
            ? formData.selectedCategory?.value
            : null,
        thumbnailUrl: shareData.channelData!.thumbnailUrl,
      );

      await SupabaseService.saveChannel(channel);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// Sharing intent stream provider - listens to shared content
final sharingIntentStreamProvider =
    StreamProvider<List<SharedMediaFile>>((ref) {
  return ReceiveSharingIntent.instance.getMediaStream();
});

// Text sharing intent stream provider - listens to shared text/URLs
// final textSharingIntentStreamProvider = StreamProvider<String>((ref) {
//   return ReceiveSharingIntent.instance.getTextStream();
// });

// App initialization provider
final appInitProvider = FutureProvider<bool>((ref) async {
  try {
    // Check if Supabase is configured
    if (!AppConfig.isSupabaseConfigured) {
      throw Exception('Supabase not configured');
    }

    // Initialize Supabase
    await SupabaseService.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );

    // Test connection
    final isConnected = await SupabaseService.testConnection();

    return isConnected;
  } catch (e) {
    return false;
  }
});

// Statistics provider
final statsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await SupabaseService.getStats();
});

// Channels list provider
final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  return await SupabaseService.getChannels();
});
