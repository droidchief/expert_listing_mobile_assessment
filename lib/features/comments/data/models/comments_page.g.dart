// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsPage _$CommentsPageFromJson(Map<String, dynamic> json) => CommentsPage(
  data: json['data'] == null
      ? const []
      : _commentsFromJson(json['data'] as List?),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CommentsPageToJson(CommentsPage instance) =>
    <String, dynamic>{
      'data': _commentsToJson(instance.data),
      'pagination': instance.pagination.toJson(),
    };
