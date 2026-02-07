// lib/core/models/short.dart
import 'package:json_annotation/json_annotation.dart';
import 'source_channel.dart';
import 'admin_channel.dart';
import 'user.dart';
import 'short_comment.dart';

part 'short.g.dart';

@JsonSerializable()
class Short {
  final String id;
  final String videoId;
  final String videoUrl;
  final SourceChannel sourceChannel;
  final String status; // ROLLED, RETAINED, REJECTED, ASSIGNED, IN_PROGRESS, COMPLETED, VALIDATED, PUBLISHED
  final DateTime rolledAt;
  final DateTime? retainedAt;
  final DateTime? rejectedAt;
  final User? assignedTo;
  final User? assignedBy;
  final DateTime? assignedAt;
  final DateTime? deadline;
  final AdminChannel? targetChannel;
  final DateTime? completedAt;
  final DateTime? validatedAt;
  final DateTime? publishedAt;
  final String? title;
  final String? description;
  final List<String> tags;
  final String? notes;
  final String? adminFeedback;
  final bool isLate;
  final int? daysUntilDeadline;
  final double? timeToComplete;

  // Google Drive fields
  final String? driveFileId;
  final String? driveFileUrl;
  final String? driveFolderId;
  final DateTime? uploadedAt;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;

  // Comments
  final List<ShortComment> comments;

  final DateTime createdAt;
  final DateTime updatedAt;

  Short({
    required this.id,
    required this.videoId,
    required this.videoUrl,
    required this.sourceChannel,
    required this.status,
    required this.rolledAt,
    this.retainedAt,
    this.rejectedAt,
    this.assignedTo,
    this.assignedBy,
    this.assignedAt,
    this.deadline,
    this.targetChannel,
    this.completedAt,
    this.validatedAt,
    this.publishedAt,
    this.title,
    this.description,
    required this.tags,
    this.notes,
    this.adminFeedback,
    required this.isLate,
    this.daysUntilDeadline,
    this.timeToComplete,
    this.driveFileId,
    this.driveFileUrl,
    this.driveFolderId,
    this.uploadedAt,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.comments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Short.fromJson(Map<String, dynamic> json) => _$ShortFromJson(json);
  Map<String, dynamic> toJson() => _$ShortToJson(this);

  // Helper getters
  bool get isRolled => status == 'ROLLED';
  bool get isRetained => status == 'RETAINED';
  bool get isRejected => status == 'REJECTED';
  bool get isAssigned => status == 'ASSIGNED';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isCompleted => status == 'COMPLETED';
  bool get isValidated => status == 'VALIDATED';
  bool get isPublished => status == 'PUBLISHED';

  bool get hasFile => driveFileUrl != null && driveFileUrl!.isNotEmpty;

  String get statusLabel {
    switch (status) {
      case 'ROLLED':
        return 'Rollé';
      case 'RETAINED':
        return 'Retenu';
      case 'REJECTED':
        return 'Rejeté';
      case 'ASSIGNED':
        return 'Assigné';
      case 'IN_PROGRESS':
        return 'En cours';
      case 'COMPLETED':
        return 'Terminé';
      case 'VALIDATED':
        return 'Validé';
      case 'PUBLISHED':
        return 'Publié';
      default:
        return status;
    }
  }
}
