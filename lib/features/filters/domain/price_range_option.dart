import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'price_range_option.g.dart';

@JsonSerializable()
class PriceRangeOption extends Equatable {
  const PriceRangeOption({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory PriceRangeOption.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeOptionFromJson(json);

  final double min;
  final double max;
  final String currency;

  Map<String, dynamic> toJson() => _$PriceRangeOptionToJson(this);

  @override
  List<Object?> get props => [min, max, currency];
}
