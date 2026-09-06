// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPrice _$PostPriceFromJson(Map<String, dynamic> json) => PostPrice(
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  period: json['period'] as String?,
  negotiable: json['negotiable'] as bool,
);

Map<String, dynamic> _$PostPriceToJson(PostPrice instance) => <String, dynamic>{
  'amount': instance.amount,
  'currency': instance.currency,
  'period': instance.period,
  'negotiable': instance.negotiable,
};
