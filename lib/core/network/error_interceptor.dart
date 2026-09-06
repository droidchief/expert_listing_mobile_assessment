import 'package:dio/dio.dart';

import '../error/failure.dart';

/// Converts every `DioException` into a typed [Failure] and throws it in
/// place of calling `handler.reject`. Dio re-wraps whatever an interceptor
/// throws as `DioException(error: <thrown value>)`, so [DioClient]'s
/// request methods unwrap `.error` to surface the [Failure] — by the time
/// code above `core/network/` sees anything, it is a [Failure], never a
/// `DioException`.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    throw _toFailure(err);
  }

  Failure _toFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return const NetworkFailure();
      case DioExceptionType.cancel:
        return const UnknownFailure('The request was cancelled.');
      case DioExceptionType.badResponse:
        return _fromErrorEnvelope(err) ?? const UnknownFailure();
      case DioExceptionType.unknown:
        return const NetworkFailure();
    }
  }

  Failure? _fromErrorEnvelope(DioException err) {
    final Object? data = err.response?.data;
    if (data is! Map<String, dynamic>) return null;
    final Object? errorJson = data['error'];
    if (errorJson is! Map<String, dynamic>) return null;

    final int? statusCode = err.response?.statusCode;
    return ServerFailure(
      code: errorJson['code'] as String? ?? 'UNKNOWN_ERROR',
      message: errorJson['message'] as String? ??
          'Something went wrong. Please try again.',
      retryable: errorJson['retryable'] as bool? ?? _isRetryableStatus(statusCode),
    );
  }

  bool _isRetryableStatus(int? statusCode) =>
      statusCode != null && (statusCode == 429 || statusCode >= 500);
}
