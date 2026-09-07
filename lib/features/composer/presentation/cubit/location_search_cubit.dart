import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../data/locations_repository.dart';
import 'location_search_state.dart';

/// Debounces keystrokes 300ms before calling `GET /locations?q=`. Loads
/// the most-used locations (empty query) immediately on construction.
class LocationSearchCubit extends Cubit<LocationSearchState> {
  LocationSearchCubit(this._repository) : super(const LocationSearchState()) {
    _fetch('');
  }

  final LocationsRepository _repository;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () => _fetch(query));
  }

  Future<void> _fetch(String query) async {
    emit(state.copyWith(status: LocationSearchStatus.loading));
    try {
      final results = await _repository.search(q: query);
      emit(state.copyWith(
        status: LocationSearchStatus.success,
        results: results,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(status: LocationSearchStatus.failure, failure: f));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
