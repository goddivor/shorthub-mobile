// YouTube data models for the mobile app
enum TagType {
  vf('VF'),
  vostfr('VOSTFR'), 
  va('VA'),
  vosta('VOSTA'),
  vo('VO');

  const TagType(this.value);
  final String value;
}

enum ChannelType {
  mix('Mix'),
  only('Only');

  const ChannelType(this.value);
  final String value;
}

enum ContentCategory {
  gaming('Gaming'),
  tech('Tech'),
  music('Music'),
  art('Art'),
  sport('Sport'),
  cuisine('Cuisine'),
  education('Education'),
  entertainment('Entertainment'),
  lifestyle('Lifestyle'),
  news('News');

  const ContentCategory(this.value);
  final String value;
}

class YouTubeChannelData {
  final String username;
  final int subscriberCount;
  final String? description;

  const YouTubeChannelData({
    required this.username,
    required this.subscriberCount,
    this.description,
  });

  factory YouTubeChannelData.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelData(
      username: json['username'] as String,
      subscriberCount: json['subscriber_count'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'subscriber_count': subscriberCount,
      'description': description,
    };
  }
}

class Channel {
  final String? id;
  final String youtubeUrl;
  final String username;
  final int subscriberCount;
  final TagType tag;
  final ChannelType type;
  final String? domain;
  final DateTime? createdAt;

  const Channel({
    this.id,
    required this.youtubeUrl,
    required this.username,
    required this.subscriberCount,
    required this.tag,
    required this.type,
    this.domain,
    this.createdAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String?,
      youtubeUrl: json['youtube_url'] as String,
      username: json['username'] as String,
      subscriberCount: json['subscriber_count'] as int,
      tag: TagType.values.firstWhere(
        (t) => t.value == json['tag'],
        orElse: () => TagType.vf,
      ),
      type: ChannelType.values.firstWhere(
        (t) => t.value == json['type'],
        orElse: () => ChannelType.mix,
      ),
      domain: json['domain'] as String?,
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'youtube_url': youtubeUrl,
      'username': username,
      'subscriber_count': subscriberCount,
      'tag': tag.value,
      'type': type.value,
      'domain': domain,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  Channel copyWith({
    String? id,
    String? youtubeUrl,
    String? username,
    int? subscriberCount,
    TagType? tag,
    ChannelType? type,
    String? domain,
    DateTime? createdAt,
  }) {
    return Channel(
      id: id ?? this.id,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      username: username ?? this.username,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      domain: domain ?? this.domain,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Share intent data model
class ShareIntentData {
  final String originalUrl;
  final String? extractedChannelUrl;
  final YouTubeChannelData? channelData;
  final bool isLoading;
  final String? error;

  const ShareIntentData({
    required this.originalUrl,
    this.extractedChannelUrl,
    this.channelData,
    this.isLoading = false,
    this.error,
  });

  ShareIntentData copyWith({
    String? originalUrl,
    String? extractedChannelUrl,
    YouTubeChannelData? channelData,
    bool? isLoading,
    String? error,
  }) {
    return ShareIntentData(
      originalUrl: originalUrl ?? this.originalUrl,
      extractedChannelUrl: extractedChannelUrl ?? this.extractedChannelUrl,
      channelData: channelData ?? this.channelData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Form state for the sharing overlay
class ChannelFormData {
  final TagType? selectedTag;
  final ChannelType? selectedType;
  final ContentCategory? selectedCategory;
  final bool isValid;

  const ChannelFormData({
    this.selectedTag,
    this.selectedType,
    this.selectedCategory,
    this.isValid = false,
  });

  ChannelFormData copyWith({
    TagType? selectedTag,
    ChannelType? selectedType,
    ContentCategory? selectedCategory,
    bool? isValid,
  }) {
    return ChannelFormData(
      selectedTag: selectedTag ?? this.selectedTag,
      selectedType: selectedType ?? this.selectedType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isValid: isValid ?? _calculateIsValid(
        selectedTag ?? this.selectedTag,
        selectedType ?? this.selectedType,
        selectedCategory ?? this.selectedCategory,
      ),
    );
  }

  static bool _calculateIsValid(
    TagType? tag,
    ChannelType? type,
    ContentCategory? category,
  ) {
    if (tag == null || type == null) return false;
    if (type == ChannelType.only && category == null) return false;
    return true;
  }
}