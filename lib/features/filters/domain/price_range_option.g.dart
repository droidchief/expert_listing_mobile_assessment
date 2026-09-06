// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_range_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRangeOption _$PriceRangeOptionFromJson(Map<String, dynamic> json) =>
    PriceRangeOption(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PriceRangeOptionToJson(PriceRangeOption instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'currency': instance.currency,
    };
