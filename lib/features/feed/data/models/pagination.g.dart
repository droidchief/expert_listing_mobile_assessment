// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  nextCursor: json['next_cursor'] as String?,
  hasMore: json['has_more'] as bool,
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'next_cursor': instance.nextCursor,
      'has_more': instance.hasMore,
      'limit': instance.limit,
    };
