// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_author_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentAuthorPreview _$CommentAuthorPreviewFromJson(
  Map<String, dynamic> json,
) => CommentAuthorPreview(
  username: json['username'] as String,
  displayName: json['display_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$CommentAuthorPreviewToJson(
  CommentAuthorPreview instance,
) => <String, dynamic>{
  'username': instance.username,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
};
