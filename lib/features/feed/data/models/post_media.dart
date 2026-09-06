import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums.dart';

part 'post_media.g.dart';

@JsonSerializable()
class PostMedia extends Equatable {
  const PostMedia({
    required this.id,
    required this.mediaType,
    required this.url,
    this.thumbnailUrl,
    this.blurhash,
    this.widthPx,
    this.heightPx,
    this.aspectRatio,
    this.durationSeconds,
    this.altText,
    required this.position,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) =>
      _$PostMediaFromJson(json);

  final String id;
  @JsonKey(unknownEnumValue: MediaType.unknown)
  final MediaType mediaType;
  final String url;
  final String? thumbnailUrl;
  final String? blurhash;
  final int? widthPx;
  final int? heightPx;
  final double? aspectRatio;
  final int? durationSeconds;
  final String? altText;
  final int position;

  Map<String, dynamic> toJson() => _$PostMediaToJson(this);

  PostMedia copyWith({
    String? id,
    MediaType? mediaType,
    String? url,
    String? thumbnailUrl,
    String? blurhash,
    int? widthPx,
    int? heightPx,
    double? aspectRatio,
    int? durationSeconds,
    String? altText,
    int? position,
  }) =>
      PostMedia(
        id: id ?? this.id,
        mediaType: mediaType ?? this.mediaType,
        url: url ?? this.url,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        blurhash: blurhash ?? this.blurhash,
        widthPx: widthPx ?? this.widthPx,
        heightPx: heightPx ?? this.heightPx,
        aspectRatio: aspectRatio ?? this.aspectRatio,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        altText: altText ?? this.altText,
        position: position ?? this.position,
      );

  @override
  List<Object?> get props => [
        id,
        mediaType,
        url,
        thumbnailUrl,
        blurhash,
        widthPx,
        heightPx,
        aspectRatio,
        durationSeconds,
        altText,
        position,
      ];
}
