import 'package:equatable/equatable.dart';

/// Typed failures the network layer converts every `DioException` into.
/// Nothing above `core/network/` should ever see a raw `DioException`.
sealed class Failure extends Equatable {
  const Failure();

  /// Safe to show to a user verbatim.
  String get userMessage;

  /// Whether the failing action is worth a Retry button.
  bool get retryable;

  @override
  List<Object?> get props => [];
}

/// No connectivity, or the connection dropped mid-request.
class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  String get userMessage =>
      'No internet connection. Check your network and try again.';

  @override
  bool get retryable => true;
}

/// The connect or receive timeout elapsed.
class TimeoutFailure extends Failure {
  const TimeoutFailure();

  @override
  String get userMessage => 'The request timed out. Please try again.';

  @override
  bool get retryable => true;
}

/// The API responded with its `{ "error": { ... } }` envelope. Carries the
/// envelope's fields through unchanged — `message` is written by the
/// backend to be shown to a user as-is, and `retryable` is the backend's
/// own call on whether a Retry button makes sense (true for 429/5xx).
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

/// Anything else — an unrecognized response shape, a JSON parse failure,
/// or a Dio error type we don't otherwise special-case.
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
