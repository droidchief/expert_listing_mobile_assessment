// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMedia _$PostMediaFromJson(Map<String, dynamic> json) => PostMedia(
  id: json['id'] as String,
  mediaType: $enumDecode(
    _$MediaTypeEnumMap,
    json['media_type'],
    unknownValue: MediaType.unknown,
  ),
  url: json['url'] as String,
  thumbnailUrl: json['thumbnail_url'] as String?,
  blurhash: json['blurhash'] as String?,
  widthPx: (json['width_px'] as num?)?.toInt(),
  heightPx: (json['height_px'] as num?)?.toInt(),
  aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
  durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
  altText: json['alt_text'] as String?,
  position: (json['position'] as num).toInt(),
);

Map<String, dynamic> _$PostMediaToJson(PostMedia instance) => <String, dynamic>{
  'id': instance.id,
  'media_type': _$MediaTypeEnumMap[instance.mediaType]!,
  'url': instance.url,
  'thumbnail_url': instance.thumbnailUrl,
  'blurhash': instance.blurhash,
  'width_px': instance.widthPx,
  'height_px': instance.heightPx,
  'aspect_ratio': instance.aspectRatio,
  'duration_seconds': instance.durationSeconds,
  'alt_text': instance.altText,
  'position': instance.position,
};

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.unknown: 'unknown',
};
