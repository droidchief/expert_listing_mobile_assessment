// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCommentResult _$CreateCommentResultFromJson(Map<String, dynamic> json) =>
    CreateCommentResult(
      comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
      postCommentCount: (json['post_comment_count'] as num).toInt(),
    );

Map<String, dynamic> _$CreateCommentResultToJson(
  CreateCommentResult instance,
) => <String, dynamic>{
  'comment': instance.comment.toJson(),
  'post_comment_count': instance.postCommentCount,
};
