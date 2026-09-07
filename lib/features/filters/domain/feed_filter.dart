import 'package:equatable/equatable.dart';

class FeedFilter extends Equatable {
  const FeedFilter({
    this.postTypes = const {},
    this.transactionTypes = const {},
    this.locationIds = const {},
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.hasMedia,
    this.postedWithin,
  });

  static const FeedFilter empty = FeedFilter();

  // Group identifiers, shared between the active-filters bar
  static const String groupPostType = 'postType';
  static const String groupTransactionType = 'transactionType';
  static const String groupLocation = 'location';
  static const String groupBedrooms = 'bedrooms';
  static const String groupPrice = 'price';
  static const String groupPostedWithin = 'postedWithin';
  static const String groupHasMedia = 'hasMedia';

  final Set<String> postTypes;
  final Set<String> transactionTypes;
  final Set<String> locationIds;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final bool? hasMedia;
  final String? postedWithin;

  bool get isActive =>
      postTypes.isNotEmpty ||
      transactionTypes.isNotEmpty ||
      locationIds.isNotEmpty ||
      minPrice != null ||
      maxPrice != null ||
      minBedrooms != null ||
      hasMedia != null ||
      postedWithin != null;

  /// Counts *groups* that are active, not individual selections 
  int get activeCount => [
        postTypes.isNotEmpty,
        transactionTypes.isNotEmpty,
        locationIds.isNotEmpty,
        minPrice != null || maxPrice != null,
        minBedrooms != null,
        hasMedia != null,
        postedWithin != null,
      ].where((active) => active).length;

  Map<String, dynamic> toQueryParams() => {
        if (postTypes.isNotEmpty) 'post_type': postTypes.join(','),
        if (transactionTypes.isNotEmpty)
          'transaction_type': transactionTypes.join(','),
        if (locationIds.isNotEmpty) 'location_id': locationIds.join(','),
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minBedrooms != null) 'min_bedrooms': minBedrooms,
        if (hasMedia != null) 'has_media': hasMedia,
        if (postedWithin != null) 'posted_within': postedWithin,
      };

  FeedFilter copyWith({
    Set<String>? postTypes,
    Set<String>? transactionTypes,
    Set<String>? locationIds,
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    int? minBedrooms,
    bool clearMinBedrooms = false,
    bool? hasMedia,
    bool clearHasMedia = false,
    String? postedWithin,
    bool clearPostedWithin = false,
  }) =>
      FeedFilter(
        postTypes: postTypes ?? this.postTypes,
        transactionTypes: transactionTypes ?? this.transactionTypes,
        locationIds: locationIds ?? this.locationIds,
        minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
        maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
        minBedrooms:
            clearMinBedrooms ? null : (minBedrooms ?? this.minBedrooms),
        hasMedia: clearHasMedia ? null : (hasMedia ?? this.hasMedia),
        postedWithin:
            clearPostedWithin ? null : (postedWithin ?? this.postedWithin),
      );

  FeedFilter withoutGroup(String group) => switch (group) {
        groupPostType => copyWith(postTypes: const {}),
        groupTransactionType => copyWith(transactionTypes: const {}),
        groupLocation => copyWith(locationIds: const {}),
        groupBedrooms => copyWith(clearMinBedrooms: true),
        groupPrice => copyWith(clearMinPrice: true, clearMaxPrice: true),
        groupPostedWithin => copyWith(clearPostedWithin: true),
        groupHasMedia => copyWith(clearHasMedia: true),
        _ => this,
      };

  @override
  List<Object?> get props => [
        postTypes,
        transactionTypes,
        locationIds,
        minPrice,
        maxPrice,
        minBedrooms,
        hasMedia,
        postedWithin,
      ];
}
