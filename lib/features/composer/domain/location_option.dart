import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_option.g.dart';

/// A `GET /locations` result. Distinct from the filters feature's own
/// `LocationOption` — that one mirrors `/filters/options`'s smaller
/// `{id, label, post_count}` shape, this one the fuller shape `/locations`
/// actually returns. The two features never import each other's, so the
/// shared class name doesn't collide.
@JsonSerializable()
class LocationOption extends Equatable {
  const LocationOption({
    required this.id,
    required this.name,
    required this.displayLabel,
    required this.city,
    required this.state,
    required this.level,
    required this.postCount,
  });

  factory LocationOption.fromJson(Map<String, dynamic> json) =>
      _$LocationOptionFromJson(json);

  final String id;
  final String name;
  final String displayLabel;
  final String city;
  final String state;
  final int level;
  final int postCount;

  Map<String, dynamic> toJson() => _$LocationOptionToJson(this);

  @override
  List<Object?> get props =>
      [id, name, displayLabel, city, state, level, postCount];
}
