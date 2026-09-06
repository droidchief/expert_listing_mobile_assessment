import 'package:json_annotation/json_annotation.dart';

/// The kind of post. Every enum in this file carries an `unknown` member so
/// that a value the backend adds later renders as unknown instead of
/// throwing a `fromJson` exception mid-scroll.
enum PostType {
  @JsonValue('general')
  general,
  @JsonValue('property')
  property,
  @JsonValue('request')
  request,
  @JsonValue('unknown')
  unknown,
}

/// The API sends `transaction_label` and `role_label` directly, but not a
/// label for `post_type` — this is the client-side equivalent.
extension PostTypeLabel on PostType {
  String get label => switch (this) {
        PostType.general => 'General',
        PostType.property => 'Property',
        PostType.request => 'Request',
        PostType.unknown => 'Unknown',
      };
}

enum TransactionType {
  @JsonValue('for_sale')
  forSale,
  @JsonValue('for_rent')
  forRent,
  @JsonValue('for_shortlet')
  forShortlet,
  @JsonValue('looking_to_buy')
  lookingToBuy,
  @JsonValue('looking_to_rent')
  lookingToRent,
  @JsonValue('looking_for_shortlet')
  lookingForShortlet,
  @JsonValue('unknown')
  unknown,
}

/// The raw API enum string, for looking chip colours up in `kChipStyles`
/// (which is keyed by that string, not by the Dart enum name).
extension TransactionTypeApiValue on TransactionType {
  String get apiValue => switch (this) {
        TransactionType.forSale => 'for_sale',
        TransactionType.forRent => 'for_rent',
        TransactionType.forShortlet => 'for_shortlet',
        TransactionType.lookingToBuy => 'looking_to_buy',
        TransactionType.lookingToRent => 'looking_to_rent',
        TransactionType.lookingForShortlet => 'looking_for_shortlet',
        TransactionType.unknown => 'unknown',
      };
}

enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('unknown')
  unknown,
}

enum UserRole {
  @JsonValue('individual')
  individual,
  @JsonValue('broker')
  broker,
  @JsonValue('agent')
  agent,
  @JsonValue('developer')
  developer,
  @JsonValue('landlord')
  landlord,
  @JsonValue('property_manager')
  propertyManager,
  @JsonValue('unknown')
  unknown,
}
