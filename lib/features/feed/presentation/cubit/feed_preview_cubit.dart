import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/fixture_loader.dart';
import 'feed_preview_state.dart';

/// Loads the five design posts from the bundled fixture, in the fixed
/// order M2's preview screen needs for side-by-side comparison against
/// Figma. Temporary — M3 replaces this with the real feed assembly.
class FeedPreviewCubit extends Cubit<FeedPreviewState> {
  FeedPreviewCubit() : super(const FeedPreviewState());

  static const List<String> _designPostIds = [
    '20000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000002',
    '20000000-0000-0000-0000-000000000003',
    '20000000-0000-0000-0000-000000000004',
    '20000000-0000-0000-0000-000000000005',
  ];

  Future<void> loadDesignPosts() async {
    emit(state.copyWith(status: FeedPreviewStatus.loading));
    try {
      final feedPage = await loadFeedFixture();
      final byId = {for (final post in feedPage.data) post.id: post};
      final posts = [
        for (final id in _designPostIds)
          if (byId[id] != null) byId[id]!,
      ];
      emit(state.copyWith(
        status: FeedPreviewStatus.success,
        posts: posts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedPreviewStatus.failure,
        failureMessage: e.toString(),
      ));
    }
  }
}
