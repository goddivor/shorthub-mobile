// lib/core/models/short_comment.dart
import 'package:json_annotation/json_annotation.dart';

part 'short_comment.g.dart';

@JsonSerializable()
class ShortComment {
  final String id;
  final String comment;
  final CommentAuthor author;
  final DateTime createdAt;

  ShortComment({
    required this.id,
    required this.comment,
    required this.author,
    required this.createdAt,
  });

  factory ShortComment.fromJson(Map<String, dynamic> json) =>
      _$ShortCommentFromJson(json);
  Map<String, dynamic> toJson() => _$ShortCommentToJson(this);
}

@JsonSerializable()
class CommentAuthor {
  final String id;
  final String username;
  final String? profileImage;

  CommentAuthor({
    required this.id,
    required this.username,
    this.profileImage,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorFromJson(json);
  Map<String, dynamic> toJson() => _$CommentAuthorToJson(this);
}
