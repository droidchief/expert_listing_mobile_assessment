// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeResult _$LikeResultFromJson(Map<String, dynamic> json) => LikeResult(
  postId: json['post_id'] as String,
  hasLiked: json['has_liked'] as bool,
  likeCount: (json['like_count'] as num).toInt(),
);

Map<String, dynamic> _$LikeResultToJson(LikeResult instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'has_liked': instance.hasLiked,
      'like_count': instance.likeCount,
    };
