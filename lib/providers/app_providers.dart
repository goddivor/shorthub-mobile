import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/channel_models.dart';
import '../services/youtube_service.dart';
import '../services/supabase_service.dart';

// YouTube service provider
final youtubeServiceProvider = Provider<YouTubeService>((ref) {
  final apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';
  return YouTubeService(
    apiKey: apiKey.isEmpty ? null : apiKey,
  );
});

// Main tab provider for bottom navigation
final mainTabProvider = StateProvider<int>((ref) => 0);

// Shared URL state - what URL was shared to our app
final sharedUrlProvider = StateNotifierProvider<SharedUrlNotifier, String?>((ref) {
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

// App initialization provider - simplified since initialization is done in main()
final appInitProvider = FutureProvider<bool>((ref) async {
  try {
    // Check if Supabase is already initialized
    if (!SupabaseService.isInitialized) {
      return false;
    }

    // Test connection
    final isConnected = await SupabaseService.testConnection();
    print('🔍 Connection test result: $isConnected');
    
    return isConnected;
  } catch (e) {
    print('❌ Error in appInitProvider: $e');
    return false;
  }
});

// Channels list provider with initialization check
final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  // Ensure app is initialized first
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    throw Exception('App not properly initialized');
  }
  
  try {
    final channels = await SupabaseService.getChannels();
    print('✅ Loaded ${channels.length} channels');
    return channels;
  } catch (e) {
    print('❌ Error loading channels: $e');
    throw Exception('Failed to load channels: $e');
  }
});

// Save channel provider with initialization check
final saveChannelProvider = FutureProvider.family<void, Channel>((ref, channel) async {
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    throw Exception('App not properly initialized');
  }
  
  await SupabaseService.saveChannel(channel);
});

// Delete channel provider with initialization check
final deleteChannelProvider = FutureProvider.family<void, String>((ref, channelId) async {
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    throw Exception('App not properly initialized');
  }
  
  await SupabaseService.deleteChannel(channelId);
});

// Search channels provider with initialization check
final searchChannelsProvider = FutureProvider.family<List<Channel>, String>((ref, query) async {
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    throw Exception('App not properly initialized');
  }
  
  if (query.isEmpty) {
    return await SupabaseService.getChannels();
  }
  return await SupabaseService.searchChannels(query);
});

// Channels by tag provider
final channelsByTagProvider = FutureProvider.family<List<Channel>, TagType>((ref, tag) async {
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    throw Exception('App not properly initialized');
  }
  
  return await SupabaseService.getChannelsByTag(tag);
});

// Channels by type provider
final channelsByTypeProvider = FutureProvider.family<List<Channel>, ChannelType>((ref, type) async {
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    throw Exception('App not properly initialized');
  }
  
  return await SupabaseService.getChannelsByType(type);
});

// Basic statistics provider
final basicStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final isInitialized = await ref.watch(appInitProvider.future);
  if (!isInitialized) {
    return {
      'total_channels': 0,
      'vf_channels': 0,
      'vostfr_channels': 0,
      'mix_channels': 0,
      'only_channels': 0,
    };
  }
  
  try {
    return await SupabaseService.getBasicStats();
  } catch (e) {
    print('❌ Error loading stats: $e');
    return {
      'total_channels': 0,
      'vf_channels': 0,
      'vostfr_channels': 0,
      'mix_channels': 0,
      'only_channels': 0,
    };
  }
});

// Channel form state provider for the add channel screen
final channelFormProvider = StateNotifierProvider<ChannelFormNotifier, ChannelFormState>((ref) {
  return ChannelFormNotifier();
});

class ChannelFormState {
  final String url;
  final YouTubeChannelData? channelData;
  final TagType? selectedTag;
  final ChannelType? selectedType;
  final ContentCategory? selectedCategory;
  final bool isExtracting;
  final String? errorMessage;

  const ChannelFormState({
    this.url = '',
    this.channelData,
    this.selectedTag,
    this.selectedType,
    this.selectedCategory,
    this.isExtracting = false,
    this.errorMessage,
  });

  ChannelFormState copyWith({
    String? url,
    YouTubeChannelData? channelData,
    TagType? selectedTag,
    ChannelType? selectedType,
    ContentCategory? selectedCategory,
    bool? isExtracting,
    String? errorMessage,
    bool clearChannelData = false,
    bool clearError = false,
  }) {
    return ChannelFormState(
      url: url ?? this.url,
      channelData: clearChannelData ? null : (channelData ?? this.channelData),
      selectedTag: selectedTag ?? this.selectedTag,
      selectedType: selectedType ?? this.selectedType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isExtracting: isExtracting ?? this.isExtracting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isValid {
    return channelData != null && 
           selectedTag != null && 
           selectedType != null &&
           (selectedType != ChannelType.only || selectedCategory != null);
  }
}

class ChannelFormNotifier extends StateNotifier<ChannelFormState> {
  ChannelFormNotifier() : super(const ChannelFormState());

  void setUrl(String url) {
    state = state.copyWith(
      url: url,
      clearChannelData: true,
      clearError: true,
    );
  }

  void setChannelData(YouTubeChannelData channelData) {
    state = state.copyWith(
      channelData: channelData,
      clearError: true,
    );
  }

  void setExtracting(bool isExtracting) {
    state = state.copyWith(isExtracting: isExtracting);
  }

  void setError(String error) {
    state = state.copyWith(
      errorMessage: error,
      isExtracting: false,
      clearChannelData: true,
    );
  }

  void setTag(TagType tag) {
    state = state.copyWith(selectedTag: tag);
  }

  void setType(ChannelType type) {
    state = state.copyWith(
      selectedType: type,
      selectedCategory: type == ChannelType.mix ? null : state.selectedCategory,
    );
  }

  void setCategory(ContentCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void reset() {
    state = const ChannelFormState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// Loading state provider for various operations
final loadingProvider = StateProvider<bool>((ref) => false);

// Error state provider for global error handling
final errorProvider = StateProvider<String?>((ref) => null);

// Filter state provider for channels list
final channelFilterProvider = StateNotifierProvider<ChannelFilterNotifier, ChannelFilterState>((ref) {
  return ChannelFilterNotifier();
});

class ChannelFilterState {
  final String searchQuery;
  final TagType? selectedTag;
  final ChannelType? selectedType;
  final bool showFilters;

  const ChannelFilterState({
    this.searchQuery = '',
    this.selectedTag,
    this.selectedType,
    this.showFilters = false,
  });

  ChannelFilterState copyWith({
    String? searchQuery,
    TagType? selectedTag,
    ChannelType? selectedType,
    bool? showFilters,
    bool clearTag = false,
    bool clearType = false,
  }) {
    return ChannelFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTag: clearTag ? null : (selectedTag ?? this.selectedTag),
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      showFilters: showFilters ?? this.showFilters,
    );
  }

  bool get hasActiveFilters {
    return searchQuery.isNotEmpty || selectedTag != null || selectedType != null;
  }
}

class ChannelFilterNotifier extends StateNotifier<ChannelFilterState> {
  ChannelFilterNotifier() : super(const ChannelFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setTag(TagType? tag) {
    state = state.copyWith(selectedTag: tag);
  }

  void setType(ChannelType? type) {
    state = state.copyWith(selectedType: type);
  }

  void toggleFilters() {
    state = state.copyWith(showFilters: !state.showFilters);
  }

  void clearFilters() {
    state = ChannelFilterState(showFilters: state.showFilters);
  }

  void reset() {
    state = const ChannelFilterState();
  }
}

// Filtered channels provider that applies search and filters
final filteredChannelsProvider = FutureProvider<List<Channel>>((ref) async {
  final allChannels = await ref.watch(channelsProvider.future);
  final filterState = ref.watch(channelFilterProvider);

  List<Channel> filteredChannels = List.from(allChannels);

  // Apply search filter
  if (filterState.searchQuery.isNotEmpty) {
    final query = filterState.searchQuery.toLowerCase();
    filteredChannels = filteredChannels.where((channel) {
      return channel.username.toLowerCase().contains(query) ||
             (channel.domain?.toLowerCase().contains(query) ?? false) ||
             channel.youtubeUrl.toLowerCase().contains(query);
    }).toList();
  }

  // Apply tag filter
  if (filterState.selectedTag != null) {
    filteredChannels = filteredChannels.where((channel) {
      return channel.tag == filterState.selectedTag;
    }).toList();
  }

  // Apply type filter
  if (filterState.selectedType != null) {
    filteredChannels = filteredChannels.where((channel) {
      return channel.type == filterState.selectedType;
    }).toList();
  }

  return filteredChannels;
});

// Connection status provider
final connectionStatusProvider = FutureProvider<bool>((ref) async {
  try {
    return await SupabaseService.testConnection();
  } catch (e) {
    return false;
  }
});

// Schema validation provider
final schemaValidationProvider = FutureProvider<bool>((ref) async {
  try {
    final isInitialized = await ref.watch(appInitProvider.future);
    if (!isInitialized) return false;
    
    return await SupabaseService.validateSchema();
  } catch (e) {
    return false;
  }
});

// App configuration provider
final appConfigProvider = Provider<Map<String, String>>((ref) {
  return {
    'youtube_api_key': dotenv.env['YOUTUBE_API_KEY'] ?? '',
    'supabase_url': dotenv.env['SUPABASE_URL'] ?? '',
    'supabase_anon_key': dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    'app_name': dotenv.env['APP_NAME'] ?? 'ShortHub',
    'app_version': dotenv.env['APP_VERSION'] ?? '1.0.0',
  };
});

// Debug info provider
final debugInfoProvider = Provider<Map<String, dynamic>>((ref) {
  final config = ref.watch(appConfigProvider);
  
  return {
    'youtube_configured': config['youtube_api_key']!.isNotEmpty,
    'supabase_configured': config['supabase_url']!.isNotEmpty && config['supabase_anon_key']!.isNotEmpty,
    'supabase_initialized': SupabaseService.isInitialized,
    'app_name': config['app_name'],
    'app_version': config['app_version'],
    'youtube_key_length': config['youtube_api_key']!.length,
    'supabase_url_length': config['supabase_url']!.length,
    'supabase_key_length': config['supabase_anon_key']!.length,
  };
});