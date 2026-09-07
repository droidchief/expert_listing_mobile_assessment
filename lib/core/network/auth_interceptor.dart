import 'package:dio/dio.dart';

import 'api_config.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['X-User-Id'] = ApiConfig.mockUserId;
    handler.next(options);
  }
}
