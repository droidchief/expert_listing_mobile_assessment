import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter_chip_option.g.dart';

@JsonSerializable()
class FilterChipOption extends Equatable {
  const FilterChipOption({required this.value, required this.label});

  factory FilterChipOption.fromJson(Map<String, dynamic> json) =>
      _$FilterChipOptionFromJson(json);

  final String value;
  final String label;

  Map<String, dynamic> toJson() => _$FilterChipOptionToJson(this);

  @override
  List<Object?> get props => [value, label];
}
