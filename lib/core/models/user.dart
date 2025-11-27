// lib/core/models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String? email;
  final String? role; // ADMIN, VIDEASTE, ASSISTANT
  final String? status; // ACTIVE, BLOCKED
  final String? phone;
  final bool? whatsappLinked;
  final bool? emailNotifications;
  final bool? whatsappNotifications;
  final String? profileImage;
  final DateTime? lastLogin;
  final UserStats? stats;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    this.email,
    this.role,
    this.status,
    this.phone,
    this.whatsappLinked,
    this.emailNotifications,
    this.whatsappNotifications,
    this.profileImage,
    this.lastLogin,
    this.stats,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool get isAdmin => role == 'ADMIN';
  bool get isVideaste => role == 'VIDEASTE';
  bool get isAssistant => role == 'ASSISTANT';
  bool get isActive => status == 'ACTIVE';
  bool get isBlocked => status == 'BLOCKED';
}

@JsonSerializable()
class UserStats {
  final int totalVideosAssigned;
  final int totalVideosCompleted;
  final int totalVideosInProgress;
  final double completionRate;
  final double? averageCompletionTime;
  final int videosCompletedThisMonth;
  final int videosLate;
  final int videosOnTime;

  UserStats({
    required this.totalVideosAssigned,
    required this.totalVideosCompleted,
    required this.totalVideosInProgress,
    required this.completionRate,
    this.averageCompletionTime,
    required this.videosCompletedThisMonth,
    required this.videosLate,
    required this.videosOnTime,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);
}
