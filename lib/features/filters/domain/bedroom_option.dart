import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bedroom_option.g.dart';

@JsonSerializable()
class BedroomOption extends Equatable {
  const BedroomOption({required this.value, required this.label});

  factory BedroomOption.fromJson(Map<String, dynamic> json) =>
      _$BedroomOptionFromJson(json);

  final int value;
  final String label;

  Map<String, dynamic> toJson() => _$BedroomOptionToJson(this);

  @override
  List<Object?> get props => [value, label];
}
