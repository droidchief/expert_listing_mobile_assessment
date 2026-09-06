// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationOption _$LocationOptionFromJson(Map<String, dynamic> json) =>
    LocationOption(
      id: json['id'] as String,
      label: json['label'] as String,
      postCount: (json['post_count'] as num).toInt(),
    );

Map<String, dynamic> _$LocationOptionToJson(LocationOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'post_count': instance.postCount,
    };
