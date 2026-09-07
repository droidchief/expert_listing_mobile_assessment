import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import 'models/comments_page.dart';
import 'models/create_comment_result.dart';

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
