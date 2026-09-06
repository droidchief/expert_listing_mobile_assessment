/// Not wired into the feed yet — a later part will expose these through
/// the UI. Exists now so `FeedRepository.getFeed` doesn't need a signature
/// change when it happens.
class FeedFilters {
  const FeedFilters({
    this.postType,
    this.transactionType,
    this.locationId,
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.hasMedia,
    this.postedWithin,
  });

  final String? postType;
  final String? transactionType;
  final String? locationId;
  final num? minPrice;
  final num? maxPrice;
  final int? minBedrooms;
  final bool? hasMedia;
  final String? postedWithin;

  Map<String, dynamic> toQueryParameters() => {
        if (postType != null) 'post_type': postType,
        if (transactionType != null) 'transaction_type': transactionType,
        if (locationId != null) 'location_id': locationId,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minBedrooms != null) 'min_bedrooms': minBedrooms,
        if (hasMedia != null) 'has_media': hasMedia,
        if (postedWithin != null) 'posted_within': postedWithin,
      };
}
