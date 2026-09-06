import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_option.g.dart';

/// Carries the `post_type` it belongs to — `for_sale` only exists on
/// `property` posts, `looking_to_buy` only on `request` posts. The sheet
/// uses this to hide transaction chips that don't apply to the selected
/// post type.
@JsonSerializable()
class TransactionOption extends Equatable {
  const TransactionOption({
    required this.value,
    required this.label,
    required this.postType,
  });

  factory TransactionOption.fromJson(Map<String, dynamic> json) =>
      _$TransactionOptionFromJson(json);

  final String value;
  final String label;
  final String postType;

  Map<String, dynamic> toJson() => _$TransactionOptionToJson(this);

  @override
  List<Object?> get props => [value, label, postType];
}
