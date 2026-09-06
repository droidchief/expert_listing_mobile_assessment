// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCounts _$PostCountsFromJson(Map<String, dynamic> json) => PostCounts(
  likes: (json['likes'] as num).toInt(),
  comments: (json['comments'] as num).toInt(),
  shares: (json['shares'] as num).toInt(),
  bookmarks: (json['bookmarks'] as num).toInt(),
  views: (json['views'] as num).toInt(),
);

Map<String, dynamic> _$PostCountsToJson(PostCounts instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'comments': instance.comments,
      'shares': instance.shares,
      'bookmarks': instance.bookmarks,
      'views': instance.views,
    };
