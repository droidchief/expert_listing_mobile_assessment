import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/feed_filter.dart';

/// Holds the *applied* filter — the draft the sheet edits while it's open
/// lives in the sheet's own widget state, not here.
class FeedFilterCubit extends Cubit<FeedFilter> {
  FeedFilterCubit() : super(FeedFilter.empty);

  void apply(FeedFilter filter) => emit(filter);

  void clear() => emit(FeedFilter.empty);

  void removeGroup(String group) => emit(state.withoutGroup(group));
}
