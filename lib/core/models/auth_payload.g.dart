// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthPayload _$AuthPayloadFromJson(Map<String, dynamic> json) => AuthPayload(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthPayloadToJson(AuthPayload instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
