// lib/core/models/notification.dart
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class AppNotification {
  final String id;
  final String type; // VIDEO_ASSIGNED, DEADLINE_REMINDER, VIDEO_COMPLETED, etc.
  final String message;
  final bool sentViaEmail;
  final bool sentViaWhatsApp;
  final bool sentViaPlatform;
  final DateTime? emailSentAt;
  final DateTime? whatsappSentAt;
  final DateTime? platformSentAt;
  final bool read;
  final DateTime? readAt;
  final String? shortId; // ID of related short
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.sentViaEmail,
    required this.sentViaWhatsApp,
    required this.sentViaPlatform,
    this.emailSentAt,
    this.whatsappSentAt,
    this.platformSentAt,
    required this.read,
    this.readAt,
    this.shortId,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  String get typeLabel {
    switch (type) {
      case 'VIDEO_ASSIGNED':
        return 'Short assigné';
      case 'DEADLINE_REMINDER':
        return 'Rappel deadline';
      case 'VIDEO_COMPLETED':
        return 'Short terminé';
      case 'VIDEO_VALIDATED':
        return 'Short validé';
      case 'VIDEO_REJECTED':
        return 'Short rejeté';
      case 'ACCOUNT_BLOCKED':
        return 'Compte bloqué';
      case 'ACCOUNT_UNBLOCKED':
        return 'Compte débloqué';
      default:
        return type;
    }
  }
}
