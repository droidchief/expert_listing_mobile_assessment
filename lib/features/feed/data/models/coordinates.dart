import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable()
class Coordinates extends Equatable {
  const Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);

  Coordinates copyWith({double? latitude, double? longitude}) => Coordinates(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  @override
  List<Object?> get props => [latitude, longitude];
}
