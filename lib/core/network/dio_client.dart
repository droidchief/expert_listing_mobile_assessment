import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../error/failure.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';


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
    
    return const UnknownFailure();
  }
}
