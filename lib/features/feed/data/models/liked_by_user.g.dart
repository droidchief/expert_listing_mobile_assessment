// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_by_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedByUser _$LikedByUserFromJson(Map<String, dynamic> json) => LikedByUser(
  username: json['username'] as String,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$LikedByUserToJson(LikedByUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'avatar_url': instance.avatarUrl,
    };
