// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyPreview _$ReplyPreviewFromJson(Map<String, dynamic> json) => ReplyPreview(
  id: json['id'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  author: ReplyAuthor.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReplyPreviewToJson(ReplyPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'author': instance.author.toJson(),
    };
