import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/filter_options.dart';

enum FilterOptionsStatus { initial, loading, success, failure }

class FilterOptionsState extends Equatable {
  const FilterOptionsState({
    this.status = FilterOptionsStatus.initial,
    this.options,
    this.failure,
  });

  final FilterOptionsStatus status;
  final FilterOptions? options;
  final Failure? failure;

  FilterOptionsState copyWith({
    FilterOptionsStatus? status,
    FilterOptions? options,
    Failure? failure,
  }) =>
      FilterOptionsState(
        status: status ?? this.status,
        options: options ?? this.options,
        failure: failure ?? this.failure,
      );

  @override
  List<Object?> get props => [status, options, failure];
}
