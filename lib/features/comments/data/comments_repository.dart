import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import 'models/comments_page.dart';
import 'models/create_comment_result.dart';

/// Talks to `GET/POST /posts/:id/comments`. Failures propagate as-is —
/// [DioClient] has already converted them to [Failure].
class CommentsRepository {
  const CommentsRepository(this._dioClient);

  final DioClient _dioClient;

  Future<CommentsPage> getComments({
    required String postId,
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/posts/$postId/comments',
      queryParameters: {
        'limit': limit,
        'sort': 'newest',
        'cursor': ?cursor,
      },
    );

    try {
      return CommentsPage.fromJson(response.data!);
    } catch (_) {
      throw const UnknownFailure('Something went wrong loading comments.');
    }
  }

  /// `clientToken` must be generated once per send *attempt* and reused
  /// across retries of that same attempt — the server uses it to make the
  /// write idempotent (a stalled request retried with the same token
  /// returns the original comment instead of creating a duplicate).
  Future<CreateCommentResult> createComment({
    required String postId,
    required String body,
    required String clientToken,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '/posts/$postId/comments',
      data: {'body': body, 'client_token': clientToken},
    );

    try {
      return CreateCommentResult.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } catch (_) {
      throw const UnknownFailure('Something went wrong sending your comment.');
    }
  }
}
