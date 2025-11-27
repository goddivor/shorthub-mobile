// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Short _$ShortFromJson(Map<String, dynamic> json) => Short(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      videoUrl: json['videoUrl'] as String,
      sourceChannel:
          SourceChannel.fromJson(json['sourceChannel'] as Map<String, dynamic>),
      status: json['status'] as String,
      rolledAt: DateTime.parse(json['rolledAt'] as String),
      retainedAt: json['retainedAt'] == null
          ? null
          : DateTime.parse(json['retainedAt'] as String),
      rejectedAt: json['rejectedAt'] == null
          ? null
          : DateTime.parse(json['rejectedAt'] as String),
      assignedTo: json['assignedTo'] == null
          ? null
          : User.fromJson(json['assignedTo'] as Map<String, dynamic>),
      assignedBy: json['assignedBy'] == null
          ? null
          : User.fromJson(json['assignedBy'] as Map<String, dynamic>),
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      targetChannel: json['targetChannel'] == null
          ? null
          : AdminChannel.fromJson(
              json['targetChannel'] as Map<String, dynamic>),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      validatedAt: json['validatedAt'] == null
          ? null
          : DateTime.parse(json['validatedAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      title: json['title'] as String?,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      adminFeedback: json['adminFeedback'] as String?,
      isLate: json['isLate'] as bool,
      daysUntilDeadline: (json['daysUntilDeadline'] as num?)?.toInt(),
      timeToComplete: (json['timeToComplete'] as num?)?.toDouble(),
      driveFileId: json['driveFileId'] as String?,
      driveFileUrl: json['driveFileUrl'] as String?,
      driveFolderId: json['driveFolderId'] as String?,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
      fileName: json['fileName'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      mimeType: json['mimeType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ShortToJson(Short instance) => <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'videoUrl': instance.videoUrl,
      'sourceChannel': instance.sourceChannel,
      'status': instance.status,
      'rolledAt': instance.rolledAt.toIso8601String(),
      'retainedAt': instance.retainedAt?.toIso8601String(),
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'assignedTo': instance.assignedTo,
      'assignedBy': instance.assignedBy,
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'deadline': instance.deadline?.toIso8601String(),
      'targetChannel': instance.targetChannel,
      'completedAt': instance.completedAt?.toIso8601String(),
      'validatedAt': instance.validatedAt?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'notes': instance.notes,
      'adminFeedback': instance.adminFeedback,
      'isLate': instance.isLate,
      'daysUntilDeadline': instance.daysUntilDeadline,
      'timeToComplete': instance.timeToComplete,
      'driveFileId': instance.driveFileId,
      'driveFileUrl': instance.driveFileUrl,
      'driveFolderId': instance.driveFolderId,
      'uploadedAt': instance.uploadedAt?.toIso8601String(),
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
