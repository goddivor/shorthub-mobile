// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      phone: json['phone'] as String?,
      whatsappLinked: json['whatsappLinked'] as bool?,
      emailNotifications: json['emailNotifications'] as bool?,
      whatsappNotifications: json['whatsappNotifications'] as bool?,
      profileImage: json['profileImage'] as String?,
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      stats: json['stats'] == null
          ? null
          : UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'phone': instance.phone,
      'whatsappLinked': instance.whatsappLinked,
      'emailNotifications': instance.emailNotifications,
      'whatsappNotifications': instance.whatsappNotifications,
      'profileImage': instance.profileImage,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'stats': instance.stats,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
      totalVideosAssigned: (json['totalVideosAssigned'] as num).toInt(),
      totalVideosCompleted: (json['totalVideosCompleted'] as num).toInt(),
      totalVideosInProgress: (json['totalVideosInProgress'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      averageCompletionTime:
          (json['averageCompletionTime'] as num?)?.toDouble(),
      videosCompletedThisMonth:
          (json['videosCompletedThisMonth'] as num).toInt(),
      videosLate: (json['videosLate'] as num).toInt(),
      videosOnTime: (json['videosOnTime'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
      'totalVideosAssigned': instance.totalVideosAssigned,
      'totalVideosCompleted': instance.totalVideosCompleted,
      'totalVideosInProgress': instance.totalVideosInProgress,
      'completionRate': instance.completionRate,
      'averageCompletionTime': instance.averageCompletionTime,
      'videosCompletedThisMonth': instance.videosCompletedThisMonth,
      'videosLate': instance.videosLate,
      'videosOnTime': instance.videosOnTime,
    };
