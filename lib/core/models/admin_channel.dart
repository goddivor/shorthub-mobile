// lib/core/models/admin_channel.dart
import 'package:json_annotation/json_annotation.dart';

part 'admin_channel.g.dart';

@JsonSerializable()
class AdminChannel {
  final String id;
  final String channelId;
  final String channelName;
  final String? profileImageUrl;
  final String? contentType; // VA_SANS_EDIT, VA_AVEC_EDIT, VF_SANS_EDIT, VF_AVEC_EDIT
  final int? totalVideos;
  final int? subscriberCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminChannel({
    required this.id,
    required this.channelId,
    required this.channelName,
    this.profileImageUrl,
    this.contentType,
    this.totalVideos,
    this.subscriberCount,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminChannel.fromJson(Map<String, dynamic> json) =>
      _$AdminChannelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminChannelToJson(this);

  String get contentTypeLabel {
    if (contentType == null) return '-';
    switch (contentType) {
      case 'VA_SANS_EDIT':
        return 'VA Sans Edit';
      case 'VA_AVEC_EDIT':
        return 'VA Avec Edit';
      case 'VF_SANS_EDIT':
        return 'VF Sans Edit';
      case 'VF_AVEC_EDIT':
        return 'VF Avec Edit';
      default:
        return contentType!;
    }
  }

  String get formattedSubscriberCount {
    if (subscriberCount == null) return '-';
    if (subscriberCount! >= 1000000) {
      return '${(subscriberCount! / 1000000).toStringAsFixed(1)}M';
    } else if (subscriberCount! >= 1000) {
      return '${(subscriberCount! / 1000).toStringAsFixed(1)}K';
    }
    return subscriberCount.toString();
  }
}
