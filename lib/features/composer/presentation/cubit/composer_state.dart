import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/location_option.dart';
import '../../domain/media_draft.dart';

enum ComposerStatus { editing, submitting, success, failure }

class ComposerState extends Equatable {
  const ComposerState({
    this.status = ComposerStatus.editing,
    this.postType = 'general',
    this.body = '',
    this.transactionType,
    this.location,
    this.media = const [],
    this.priceAmount,
    this.pricePeriod,
    this.bedrooms,
    this.bathrooms,
    this.parkingSpaces,
    this.failure,
    this.createdPostId,
  });

  // Mirrors the server's chk_transaction_direction constraint client-side.
  static const Set<String> propertyTransactionTypes = {
    'for_sale',
    'for_rent',
    'for_shortlet',
  };
  static const Set<String> requestTransactionTypes = {
    'looking_to_buy',
    'looking_to_rent',
    'looking_for_shortlet',
  };
  static const int maxMedia = 10;
  static const int maxBodyLength = 5000;

  final ComposerStatus status;
  final String postType;
  final String body;
  final String? transactionType;
  final LocationOption? location;
  final List<MediaDraft> media;
  final num? priceAmount;
  final String? pricePeriod;
  final int? bedrooms;
  final int? bathrooms;
  final int? parkingSpaces;
  final Failure? failure;
  final String? createdPostId;

  Set<String> get validTransactionTypes => switch (postType) {
        'property' => propertyTransactionTypes,
        'request' => requestTransactionTypes,
        _ => const {},
      };

  bool get hasUnsavedContent =>
      body.trim().isNotEmpty || media.isNotEmpty || location != null;

  bool get isValid {
    final String trimmed = body.trim();
    if (trimmed.isEmpty || trimmed.length > maxBodyLength) return false;
    if (postType == 'general' && transactionType != null) return false;
    if ((postType == 'property' || postType == 'request') &&
        !validTransactionTypes.contains(transactionType)) {
      return false;
    }
    if (media.any((m) => m.uploadState != MediaUploadState.uploaded)) {
      return false;
    }
    return true;
  }

  ComposerState copyWith({
    ComposerStatus? status,
    String? postType,
    String? body,
    String? transactionType,
    bool clearTransactionType = false,
    LocationOption? location,
    bool clearLocation = false,
    List<MediaDraft>? media,
    num? priceAmount,
    bool clearPriceAmount = false,
    String? pricePeriod,
    bool clearPricePeriod = false,
    int? bedrooms,
    bool clearBedrooms = false,
    int? bathrooms,
    bool clearBathrooms = false,
    int? parkingSpaces,
    bool clearParkingSpaces = false,
    Failure? failure,
    bool clearFailure = false,
    String? createdPostId,
  }) =>
      ComposerState(
        status: status ?? this.status,
        postType: postType ?? this.postType,
        body: body ?? this.body,
        transactionType: clearTransactionType
            ? null
            : (transactionType ?? this.transactionType),
        location: clearLocation ? null : (location ?? this.location),
        media: media ?? this.media,
        priceAmount:
            clearPriceAmount ? null : (priceAmount ?? this.priceAmount),
        pricePeriod:
            clearPricePeriod ? null : (pricePeriod ?? this.pricePeriod),
        bedrooms: clearBedrooms ? null : (bedrooms ?? this.bedrooms),
        bathrooms: clearBathrooms ? null : (bathrooms ?? this.bathrooms),
        parkingSpaces:
            clearParkingSpaces ? null : (parkingSpaces ?? this.parkingSpaces),
        failure: clearFailure ? null : (failure ?? this.failure),
        createdPostId: createdPostId ?? this.createdPostId,
      );

  @override
  List<Object?> get props => [
        status,
        postType,
        body,
        transactionType,
        location,
        media,
        priceAmount,
        pricePeriod,
        bedrooms,
        bathrooms,
        parkingSpaces,
        failure,
        createdPostId,
      ];
}
