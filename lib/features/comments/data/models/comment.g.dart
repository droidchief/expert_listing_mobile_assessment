// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  id: json['id'] as String,
  postId: json['post_id'] as String,
  body: json['body'] as String,
  author: CommentAuthor.fromJson(json['author'] as Map<String, dynamic>),
  counts: CommentCounts.fromJson(json['counts'] as Map<String, dynamic>),
  viewerState: CommentViewerState.fromJson(
    json['viewer_state'] as Map<String, dynamic>,
  ),
  repliesPreview: json['replies_preview'] == null
      ? const []
      : _repliesFromJson(json['replies_preview'] as List?),
  isEdited: json['is_edited'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'id': instance.id,
  'post_id': instance.postId,
  'body': instance.body,
  'author': instance.author.toJson(),
  'counts': instance.counts.toJson(),
  'viewer_state': instance.viewerState.toJson(),
  'replies_preview': _repliesToJson(instance.repliesPreview),
  'is_edited': instance.isEdited,
  'created_at': instance.createdAt.toIso8601String(),
};
