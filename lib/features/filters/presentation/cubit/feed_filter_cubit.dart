import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/feed_filter.dart';

class FeedFilterCubit extends Cubit<FeedFilter> {
  FeedFilterCubit() : super(FeedFilter.empty);

  void apply(FeedFilter filter) => emit(filter);

  void clear() => emit(FeedFilter.empty);

  void removeGroup(String group) => emit(state.withoutGroup(group));
}
