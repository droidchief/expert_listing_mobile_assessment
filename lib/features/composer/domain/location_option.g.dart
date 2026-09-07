// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationOption _$LocationOptionFromJson(Map<String, dynamic> json) =>
    LocationOption(
      id: json['id'] as String,
      name: json['name'] as String,
      displayLabel: json['display_label'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      level: (json['level'] as num).toInt(),
      postCount: (json['post_count'] as num).toInt(),
    );

Map<String, dynamic> _$LocationOptionToJson(LocationOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_label': instance.displayLabel,
      'city': instance.city,
      'state': instance.state,
      'level': instance.level,
      'post_count': instance.postCount,
    };
