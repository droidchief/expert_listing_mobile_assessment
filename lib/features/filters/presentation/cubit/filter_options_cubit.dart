import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../data/filters_repository.dart';
import 'filter_options_state.dart';

/// Fetches `/filters/options` once per session and caches it. Loaded when
/// the feed screen mounts (not when the sheet opens), so the sheet itself
/// never shows a spinner in the normal case.
class FilterOptionsCubit extends Cubit<FilterOptionsState> {
  FilterOptionsCubit(this._repository) : super(const FilterOptionsState());

  final FiltersRepository _repository;

  Future<void> load() async {
    if (state.status == FilterOptionsStatus.loading ||
        state.status == FilterOptionsStatus.success) {
      return;
    }
    emit(state.copyWith(status: FilterOptionsStatus.loading));
    try {
      final options = await _repository.getFilterOptions();
      emit(state.copyWith(
        status: FilterOptionsStatus.success,
        options: options,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(status: FilterOptionsStatus.failure, failure: f));
    }
  }
}
