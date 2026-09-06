import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_property.g.dart';

List<String> _amenitiesFromJson(List<dynamic>? json) =>
    json?.map((e) => e as String).toList() ?? const [];

@JsonSerializable()
class PostProperty extends Equatable {
  const PostProperty({
    this.bedrooms,
    this.bathrooms,
    this.parkingSpaces,
    this.sizeSqm,
    this.amenities = const [],
    this.availableFrom,
    this.inspectionAt,
  });

  factory PostProperty.fromJson(Map<String, dynamic> json) =>
      _$PostPropertyFromJson(json);

  final int? bedrooms;
  final int? bathrooms;
  final int? parkingSpaces;
  final double? sizeSqm;
  @JsonKey(fromJson: _amenitiesFromJson)
  final List<String> amenities;
  final DateTime? availableFrom;
  final DateTime? inspectionAt;

  Map<String, dynamic> toJson() => _$PostPropertyToJson(this);

  PostProperty copyWith({
    int? bedrooms,
    int? bathrooms,
    int? parkingSpaces,
    double? sizeSqm,
    List<String>? amenities,
    DateTime? availableFrom,
    DateTime? inspectionAt,
  }) =>
      PostProperty(
        bedrooms: bedrooms ?? this.bedrooms,
        bathrooms: bathrooms ?? this.bathrooms,
        parkingSpaces: parkingSpaces ?? this.parkingSpaces,
        sizeSqm: sizeSqm ?? this.sizeSqm,
        amenities: amenities ?? this.amenities,
        availableFrom: availableFrom ?? this.availableFrom,
        inspectionAt: inspectionAt ?? this.inspectionAt,
      );

  @override
  List<Object?> get props => [
        bedrooms,
        bathrooms,
        parkingSpaces,
        sizeSqm,
        amenities,
        availableFrom,
        inspectionAt,
      ];
}
