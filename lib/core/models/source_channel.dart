// lib/core/models/source_channel.dart
import 'package:json_annotation/json_annotation.dart';

part 'source_channel.g.dart';

@JsonSerializable()
class SourceChannel {
  final String id;
  final String channelId;
  final String channelName;
  final String? profileImageUrl;
  final String contentType; // VA_SANS_EDIT, VA_AVEC_EDIT, VF_SANS_EDIT, VF_AVEC_EDIT, VO_SANS_EDIT, VO_AVEC_EDIT
  final int? totalVideos;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SourceChannel({
    required this.id,
    required this.channelId,
    required this.channelName,
    this.profileImageUrl,
    required this.contentType,
    this.totalVideos,
    this.createdAt,
    this.updatedAt,
  });

  factory SourceChannel.fromJson(Map<String, dynamic> json) =>
      _$SourceChannelFromJson(json);
  Map<String, dynamic> toJson() => _$SourceChannelToJson(this);

  String get contentTypeLabel {
    switch (contentType) {
      case 'VA_SANS_EDIT':
        return 'VA Sans Edit';
      case 'VA_AVEC_EDIT':
        return 'VA Avec Edit';
      case 'VF_SANS_EDIT':
        return 'VF Sans Edit';
      case 'VF_AVEC_EDIT':
        return 'VF Avec Edit';
      case 'VO_SANS_EDIT':
        return 'VO Sans Edit';
      case 'VO_AVEC_EDIT':
        return 'VO Avec Edit';
      default:
        return contentType;
    }
  }
}
