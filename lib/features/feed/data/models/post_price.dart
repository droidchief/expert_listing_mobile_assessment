import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_price.g.dart';

@JsonSerializable()
class PostPrice extends Equatable {
  const PostPrice({
    required this.amount,
    required this.currency,
    this.period,
    required this.negotiable,
  });

  factory PostPrice.fromJson(Map<String, dynamic> json) =>
      _$PostPriceFromJson(json);

  final double amount;
  final String currency;
  final String? period;
  final bool negotiable;

  Map<String, dynamic> toJson() => _$PostPriceToJson(this);

  PostPrice copyWith({
    double? amount,
    String? currency,
    String? period,
    bool? negotiable,
  }) =>
      PostPrice(
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        period: period ?? this.period,
        negotiable: negotiable ?? this.negotiable,
      );

  @override
  List<Object?> get props => [amount, currency, period, negotiable];
}
