import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/dio_client.dart';
import '../domain/signed_upload.dart';

/// Signs an upload through the API, then PUTs the bytes straight to
/// Supabase Storage. The PUT never touches [DioClient] — a bare `Dio()`
/// carries no `X-User-Id` header and no API base URL, since the signed
/// URL is a different host entirely and already carries its own auth
/// (the signing token embedded in the URL).
class UploadRepository {
  UploadRepository(this._dioClient) : _rawDio = Dio();

  final DioClient _dioClient;
  final Dio _rawDio;

  Future<SignedUpload> signUpload({
    required String bucket,
    required String contentType,
    required int byteSize,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '/uploads/sign',
      data: {
        'bucket': bucket,
        'content_type': contentType,
        'byte_size': byteSize,
      },
    );
    try {
      return SignedUpload.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } catch (_) {
      throw const UnknownFailure('Something went wrong preparing your upload.');
    }
  }

  Future<void> uploadBytes({
    required String signedUrl,
    required Uint8List bytes,
    required String contentType,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      await _rawDio.put<void>(
        signedUrl,
        data: bytes,
        options: Options(
          headers: {'Content-Type': contentType},
        ),
        onSendProgress: onProgress,
      );
    } on DioException catch (e) {
      throw _mapUploadError(e);
    }
  }

  Failure _mapUploadError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return const NetworkFailure();
      default:
        return const UnknownFailure('Something went wrong uploading that image.');
    }
  }
}
