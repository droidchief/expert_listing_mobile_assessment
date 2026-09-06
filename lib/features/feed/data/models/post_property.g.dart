// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostProperty _$PostPropertyFromJson(Map<String, dynamic> json) => PostProperty(
  bedrooms: (json['bedrooms'] as num?)?.toInt(),
  bathrooms: (json['bathrooms'] as num?)?.toInt(),
  parkingSpaces: (json['parking_spaces'] as num?)?.toInt(),
  sizeSqm: (json['size_sqm'] as num?)?.toDouble(),
  amenities: json['amenities'] == null
      ? const []
      : _amenitiesFromJson(json['amenities'] as List?),
  availableFrom: json['available_from'] == null
      ? null
      : DateTime.parse(json['available_from'] as String),
  inspectionAt: json['inspection_at'] == null
      ? null
      : DateTime.parse(json['inspection_at'] as String),
);

Map<String, dynamic> _$PostPropertyToJson(PostProperty instance) =>
    <String, dynamic>{
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'parking_spaces': instance.parkingSpaces,
      'size_sqm': instance.sizeSqm,
      'amenities': instance.amenities,
      'available_from': instance.availableFrom?.toIso8601String(),
      'inspection_at': instance.inspectionAt?.toIso8601String(),
    };
