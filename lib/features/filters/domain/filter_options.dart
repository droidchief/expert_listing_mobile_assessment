import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bedroom_option.dart';
import 'filter_chip_option.dart';
import 'location_option.dart';
import 'price_range_option.dart';
import 'transaction_option.dart';

part 'filter_options.g.dart';

@JsonSerializable(explicitToJson: true)
class FilterOptions extends Equatable {
  const FilterOptions({
    required this.postTypes,
    required this.transactionTypes,
    required this.locations,
    required this.bedrooms,
    required this.postedWithin,
    required this.priceRange,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionsFromJson(json);

  final List<FilterChipOption> postTypes;
  final List<TransactionOption> transactionTypes;
  final List<LocationOption> locations;
  final List<BedroomOption> bedrooms;
  final List<FilterChipOption> postedWithin;
  final PriceRangeOption priceRange;

  Map<String, dynamic> toJson() => _$FilterOptionsToJson(this);

  @override
  List<Object?> get props => [
        postTypes,
        transactionTypes,
        locations,
        bedrooms,
        postedWithin,
        priceRange,
      ];
}
