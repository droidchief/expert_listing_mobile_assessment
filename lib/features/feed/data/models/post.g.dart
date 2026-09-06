// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: json['id'] as String,
  postType: $enumDecode(
    _$PostTypeEnumMap,
    json['post_type'],
    unknownValue: PostType.unknown,
  ),
  body: json['body'] as String,
  transactionType: $enumDecodeNullable(
    _$TransactionTypeEnumMap,
    json['transaction_type'],
    unknownValue: TransactionType.unknown,
  ),
  transactionLabel: json['transaction_label'] as String?,
  locationId: json['location_id'] as String?,
  locationLabel: json['location_label'] as String?,
  coordinates: json['coordinates'] == null
      ? null
      : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
  price: json['price'] == null
      ? null
      : PostPrice.fromJson(json['price'] as Map<String, dynamic>),
  property: json['property'] == null
      ? null
      : PostProperty.fromJson(json['property'] as Map<String, dynamic>),
  author: PostAuthor.fromJson(json['author'] as Map<String, dynamic>),
  showRoleBadge: json['show_role_badge'] as bool,
  media: json['media'] == null
      ? const []
      : _mediaFromJson(json['media'] as List?),
  counts: PostCounts.fromJson(json['counts'] as Map<String, dynamic>),
  viewerState: ViewerState.fromJson(
    json['viewer_state'] as Map<String, dynamic>,
  ),
  likedByPreview: LikedByPreview.fromJson(
    json['liked_by_preview'] as Map<String, dynamic>,
  ),
  topComment: json['top_comment'] == null
      ? null
      : TopComment.fromJson(json['top_comment'] as Map<String, dynamic>),
  isEdited: json['is_edited'] as bool,
  isPinned: json['is_pinned'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'post_type': _$PostTypeEnumMap[instance.postType]!,
  'body': instance.body,
  'transaction_type': _$TransactionTypeEnumMap[instance.transactionType],
  'transaction_label': instance.transactionLabel,
  'location_id': instance.locationId,
  'location_label': instance.locationLabel,
  'coordinates': instance.coordinates?.toJson(),
  'price': instance.price?.toJson(),
  'property': instance.property?.toJson(),
  'author': instance.author.toJson(),
  'show_role_badge': instance.showRoleBadge,
  'media': _mediaToJson(instance.media),
  'counts': instance.counts.toJson(),
  'viewer_state': instance.viewerState.toJson(),
  'liked_by_preview': instance.likedByPreview.toJson(),
  'top_comment': instance.topComment?.toJson(),
  'is_edited': instance.isEdited,
  'is_pinned': instance.isPinned,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$PostTypeEnumMap = {
  PostType.general: 'general',
  PostType.property: 'property',
  PostType.request: 'request',
  PostType.unknown: 'unknown',
};

const _$TransactionTypeEnumMap = {
  TransactionType.forSale: 'for_sale',
  TransactionType.forRent: 'for_rent',
  TransactionType.forShortlet: 'for_shortlet',
  TransactionType.lookingToBuy: 'looking_to_buy',
  TransactionType.lookingToRent: 'looking_to_rent',
  TransactionType.lookingForShortlet: 'looking_for_shortlet',
  TransactionType.unknown: 'unknown',
};
