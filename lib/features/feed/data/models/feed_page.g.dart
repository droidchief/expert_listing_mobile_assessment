// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedPage _$FeedPageFromJson(Map<String, dynamic> json) => FeedPage(
  data: json['data'] == null ? const [] : _postsFromJson(json['data'] as List?),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FeedPageToJson(FeedPage instance) => <String, dynamic>{
  'data': _postsToJson(instance.data),
  'pagination': instance.pagination.toJson(),
};
