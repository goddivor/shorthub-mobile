// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminChannel _$AdminChannelFromJson(Map<String, dynamic> json) => AdminChannel(
      id: json['id'] as String,
      channelId: json['channelId'] as String,
      channelName: json['channelName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      contentType: json['contentType'] as String?,
      totalVideos: (json['totalVideos'] as num?)?.toInt(),
      subscriberCount: (json['subscriberCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AdminChannelToJson(AdminChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channelId': instance.channelId,
      'channelName': instance.channelName,
      'profileImageUrl': instance.profileImageUrl,
      'contentType': instance.contentType,
      'totalVideos': instance.totalVideos,
      'subscriberCount': instance.subscriberCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
