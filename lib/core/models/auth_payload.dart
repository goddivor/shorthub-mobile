// lib/core/models/auth_payload.dart
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'auth_payload.g.dart';

@JsonSerializable()
class AuthPayload {
  final String token;
  final String refreshToken;
  final User user;

  AuthPayload({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$AuthPayloadToJson(this);
}
