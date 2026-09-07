import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_option.g.dart';

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
