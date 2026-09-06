// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_by_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedByPreview _$LikedByPreviewFromJson(Map<String, dynamic> json) =>
    LikedByPreview(
      total: (json['total'] as num).toInt(),
      users: json['users'] == null
          ? const []
          : _usersFromJson(json['users'] as List?),
    );

Map<String, dynamic> _$LikedByPreviewToJson(LikedByPreview instance) =>
    <String, dynamic>{
      'total': instance.total,
      'users': _usersToJson(instance.users),
    };
