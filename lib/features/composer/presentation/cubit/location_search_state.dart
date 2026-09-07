import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/location_option.dart';

enum LocationSearchStatus { loading, success, failure }

class LocationSearchState extends Equatable {
  const LocationSearchState({
    this.status = LocationSearchStatus.loading,
    this.results = const [],
    this.failure,
  });

  final LocationSearchStatus status;
  final List<LocationOption> results;
  final Failure? failure;

  LocationSearchState copyWith({
    LocationSearchStatus? status,
    List<LocationOption>? results,
    Failure? failure,
  }) =>
      LocationSearchState(
        status: status ?? this.status,
        results: results ?? this.results,
        failure: failure ?? this.failure,
      );

  @override
  List<Object?> get props => [status, results, failure];
}
