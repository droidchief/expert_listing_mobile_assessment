// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopComment _$TopCommentFromJson(Map<String, dynamic> json) => TopComment(
  id: json['id'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  author: CommentAuthorPreview.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TopCommentToJson(TopComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'author': instance.author.toJson(),
    };
