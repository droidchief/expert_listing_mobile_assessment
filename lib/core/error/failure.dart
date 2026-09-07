import 'package:equatable/equatable.dart';

/// Typed failures the network layer converts every `DioException` into.
/// Nothing above `core/network/` should ever see a raw `DioException`.
sealed class Failure extends Equatable {
  const Failure();

  String get userMessage;

  bool get retryable;

  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  String get userMessage =>
      'No internet connection. Check your network and try again.';

  @override
  bool get retryable => true;
}

class TimeoutFailure extends Failure {
  const TimeoutFailure();

  @override
  String get userMessage => 'The request timed out. Please try again.';

  @override
  bool get retryable => true;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required this.code,
    required this.message,
    required this.retryable,
  });

  final String code;
  final String message;

  @override
  final bool retryable;

  @override
  String get userMessage => message;

  @override
  List<Object?> get props => [code, message, retryable];
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    this.message = 'Something went wrong. Please try again.',
  ]);

  final String message;

  @override
  String get userMessage => message;

  @override
  bool get retryable => true;

  @override
  List<Object?> get props => [message];
}
