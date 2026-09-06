import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums.dart';
import 'coordinates.dart';
import 'liked_by_preview.dart';
import 'post_author.dart';
import 'post_counts.dart';
import 'post_media.dart';
import 'post_price.dart';
import 'post_property.dart';
import 'top_comment.dart';
import 'viewer_state.dart';

part 'post.g.dart';

List<PostMedia> _mediaFromJson(List<dynamic>? json) =>
    json?.map((e) => PostMedia.fromJson(e as Map<String, dynamic>)).toList() ??
    const [];

List<Map<String, dynamic>> _mediaToJson(List<PostMedia> media) =>
    media.map((e) => e.toJson()).toList();

@JsonSerializable()
class Post extends Equatable {
  const Post({
    required this.id,
    required this.postType,
    required this.body,
    this.transactionType,
    this.transactionLabel,
    this.locationId,
    this.locationLabel,
    this.coordinates,
    this.price,
    this.property,
    required this.author,
    required this.showRoleBadge,
    this.media = const [],
    required this.counts,
    required this.viewerState,
    required this.likedByPreview,
    this.topComment,
    required this.isEdited,
    required this.isPinned,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  final String id;
  @JsonKey(unknownEnumValue: PostType.unknown)
  final PostType postType;
  final String body;
  @JsonKey(unknownEnumValue: TransactionType.unknown)
  final TransactionType? transactionType;
  final String? transactionLabel;
  final String? locationId;
  final String? locationLabel;
  final Coordinates? coordinates;
  final PostPrice? price;
  final PostProperty? property;
  final PostAuthor author;
  final bool showRoleBadge;
  @JsonKey(fromJson: _mediaFromJson, toJson: _mediaToJson)
  final List<PostMedia> media;
  final PostCounts counts;
  final ViewerState viewerState;
  final LikedByPreview likedByPreview;
  final TopComment? topComment;
  final bool isEdited;
  final bool isPinned;
  // UTC per the API contract. Convert with .toLocal() at render time only —
  // never store local time here.
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$PostToJson(this);

  Post copyWith({
    String? id,
    PostType? postType,
    String? body,
    TransactionType? transactionType,
    String? transactionLabel,
    String? locationId,
    String? locationLabel,
    Coordinates? coordinates,
    PostPrice? price,
    PostProperty? property,
    PostAuthor? author,
    bool? showRoleBadge,
    List<PostMedia>? media,
    PostCounts? counts,
    ViewerState? viewerState,
    LikedByPreview? likedByPreview,
    TopComment? topComment,
    bool? isEdited,
    bool? isPinned,
    DateTime? createdAt,
  }) =>
      Post(
        id: id ?? this.id,
        postType: postType ?? this.postType,
        body: body ?? this.body,
        transactionType: transactionType ?? this.transactionType,
        transactionLabel: transactionLabel ?? this.transactionLabel,
        locationId: locationId ?? this.locationId,
        locationLabel: locationLabel ?? this.locationLabel,
        coordinates: coordinates ?? this.coordinates,
        price: price ?? this.price,
        property: property ?? this.property,
        author: author ?? this.author,
        showRoleBadge: showRoleBadge ?? this.showRoleBadge,
        media: media ?? this.media,
        counts: counts ?? this.counts,
        viewerState: viewerState ?? this.viewerState,
        likedByPreview: likedByPreview ?? this.likedByPreview,
        topComment: topComment ?? this.topComment,
        isEdited: isEdited ?? this.isEdited,
        isPinned: isPinned ?? this.isPinned,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        postType,
        body,
        transactionType,
        transactionLabel,
        locationId,
        locationLabel,
        coordinates,
        price,
        property,
        author,
        showRoleBadge,
        media,
        counts,
        viewerState,
        likedByPreview,
        topComment,
        isEdited,
        isPinned,
        createdAt,
      ];
}
