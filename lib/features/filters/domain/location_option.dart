import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_option.g.dart';

@JsonSerializable()
class LocationOption extends Equatable {
  const LocationOption({
    required this.id,
    required this.label,
    required this.postCount,
  });

  factory LocationOption.fromJson(Map<String, dynamic> json) =>
      _$LocationOptionFromJson(json);

  final String id;
  final String label;
  final int postCount;

  Map<String, dynamic> toJson() => _$LocationOptionToJson(this);

  @override
  List<Object?> get props => [id, label, postCount];
}
