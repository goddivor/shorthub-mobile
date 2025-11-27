// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      id: json['id'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      sentViaEmail: json['sentViaEmail'] as bool,
      sentViaWhatsApp: json['sentViaWhatsApp'] as bool,
      sentViaPlatform: json['sentViaPlatform'] as bool,
      emailSentAt: json['emailSentAt'] == null
          ? null
          : DateTime.parse(json['emailSentAt'] as String),
      whatsappSentAt: json['whatsappSentAt'] == null
          ? null
          : DateTime.parse(json['whatsappSentAt'] as String),
      platformSentAt: json['platformSentAt'] == null
          ? null
          : DateTime.parse(json['platformSentAt'] as String),
      read: json['read'] as bool,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      shortId: json['shortId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'sentViaEmail': instance.sentViaEmail,
      'sentViaWhatsApp': instance.sentViaWhatsApp,
      'sentViaPlatform': instance.sentViaPlatform,
      'emailSentAt': instance.emailSentAt?.toIso8601String(),
      'whatsappSentAt': instance.whatsappSentAt?.toIso8601String(),
      'platformSentAt': instance.platformSentAt?.toIso8601String(),
      'read': instance.read,
      'readAt': instance.readAt?.toIso8601String(),
      'shortId': instance.shortId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
