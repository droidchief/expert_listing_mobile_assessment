import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../error/failure.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

/// The app's single configured Dio instance, plus request methods that
/// unwrap Dio's error wrapping so nothing above this file ever sees a
/// `DioException` — only [Failure].
class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
          ),
        ) {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      if (kDebugMode)
        LogInterceptor(requestBody: false, responseBody: false),
      // Must run last so it sees the raw DioException from the request
      // itself, not one already logged/handled by an earlier interceptor.
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }

  Failure _unwrap(DioException e) {
    final Object? error = e.error;
    if (error is Failure) return error;
    // ErrorInterceptor always converts — this is an unreachable-in-
    // practice safety net, not a silent fallback.
    return const UnknownFailure();
  }
}
