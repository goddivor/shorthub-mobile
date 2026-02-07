// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortComment _$ShortCommentFromJson(Map<String, dynamic> json) => ShortComment(
      id: json['id'] as String,
      comment: json['comment'] as String,
      author: CommentAuthor.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ShortCommentToJson(ShortComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'author': instance.author,
      'createdAt': instance.createdAt.toIso8601String(),
    };

CommentAuthor _$CommentAuthorFromJson(Map<String, dynamic> json) =>
    CommentAuthor(
      id: json['id'] as String,
      username: json['username'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$CommentAuthorToJson(CommentAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profileImage': instance.profileImage,
    };
