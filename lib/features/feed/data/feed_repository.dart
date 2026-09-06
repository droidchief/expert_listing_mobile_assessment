import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import 'feed_filters.dart';
import 'models/feed_page.dart';
import 'models/like_result.dart';

/// Talks to `GET /posts`. Failures propagate as-is — [DioClient] has
/// already converted them to [Failure]; this repository does not catch or
/// convert anything itself.
class FeedRepository {
  const FeedRepository(this._dioClient);

  final DioClient _dioClient;

  Future<FeedPage> getFeed({
    String? cursor,
    int limit = 20,
    FeedFilters? filters,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'limit': limit,
      'cursor': ?cursor,
      ...?filters?.toQueryParameters(),
    };

    final response = await _dioClient.get<Map<String, dynamic>>(
      '/posts',
      queryParameters: queryParameters,
    );


    try {
      return FeedPage.fromJson(response.data!);
    } catch (_) {
      throw const UnknownFailure('Something went wrong loading posts.');
    }
  }

  /// Always sends an explicit action — never an empty (toggle) body, which
  /// would be unsafe to retry. `{"action":"like"}` / `{"action":"unlike"}`
  /// are idempotent.
  Future<LikeResult> setLike({
    required String postId,
    required bool liked,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '/posts/$postId/like',
      data: {'action': liked ? 'like' : 'unlike'},
    );

    try {
      return LikeResult.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (_) {
      throw const UnknownFailure('Something went wrong updating your like.');
    }
  }
}
