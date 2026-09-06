// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterOptions _$FilterOptionsFromJson(Map<String, dynamic> json) =>
    FilterOptions(
      postTypes: (json['post_types'] as List<dynamic>)
          .map((e) => FilterChipOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      transactionTypes: (json['transaction_types'] as List<dynamic>)
          .map((e) => TransactionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => LocationOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      bedrooms: (json['bedrooms'] as List<dynamic>)
          .map((e) => BedroomOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      postedWithin: (json['posted_within'] as List<dynamic>)
          .map((e) => FilterChipOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceRange: PriceRangeOption.fromJson(
        json['price_range'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$FilterOptionsToJson(FilterOptions instance) =>
    <String, dynamic>{
      'post_types': instance.postTypes.map((e) => e.toJson()).toList(),
      'transaction_types': instance.transactionTypes
          .map((e) => e.toJson())
          .toList(),
      'locations': instance.locations.map((e) => e.toJson()).toList(),
      'bedrooms': instance.bedrooms.map((e) => e.toJson()).toList(),
      'posted_within': instance.postedWithin.map((e) => e.toJson()).toList(),
      'price_range': instance.priceRange.toJson(),
    };
