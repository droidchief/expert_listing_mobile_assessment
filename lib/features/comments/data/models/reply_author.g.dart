// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyAuthor _$ReplyAuthorFromJson(Map<String, dynamic> json) => ReplyAuthor(
  username: json['username'] as String,
  displayName: json['display_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$ReplyAuthorToJson(ReplyAuthor instance) =>
    <String, dynamic>{
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
    };
