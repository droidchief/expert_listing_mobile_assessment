// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionOption _$TransactionOptionFromJson(Map<String, dynamic> json) =>
    TransactionOption(
      value: json['value'] as String,
      label: json['label'] as String,
      postType: json['post_type'] as String,
    );

Map<String, dynamic> _$TransactionOptionToJson(TransactionOption instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'post_type': instance.postType,
    };
