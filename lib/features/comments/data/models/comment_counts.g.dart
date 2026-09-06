// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentCounts _$CommentCountsFromJson(Map<String, dynamic> json) =>
    CommentCounts(
      likes: (json['likes'] as num).toInt(),
      replies: (json['replies'] as num).toInt(),
    );

Map<String, dynamic> _$CommentCountsToJson(CommentCounts instance) =>
    <String, dynamic>{'likes': instance.likes, 'replies': instance.replies};
