import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../../filters/domain/feed_filter.dart';
import 'models/feed_page.dart';
import 'models/like_result.dart';

class FeedRepository {
  const FeedRepository(this._dioClient);

  final DioClient _dioClient;

  Future<FeedPage> getFeed({
    String? cursor,
    int limit = 20,
    FeedFilter? filter,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'limit': limit,
      'cursor': ?cursor,
      ...?filter?.toQueryParams(),
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
