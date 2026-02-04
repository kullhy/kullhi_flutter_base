/// Network exception types
enum NetworkExceptionType {
  noInternetConnection,
  timeout,
  serverError,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  unknown,
}

/// Network Exception
class NetworkException implements Exception {
  final NetworkExceptionType type;
  final String message;
  final int? statusCode;
  final dynamic originalException;

  const NetworkException({required this.type, required this.message, this.statusCode, this.originalException});

  factory NetworkException.noInternetConnection() {
    return const NetworkException(type: NetworkExceptionType.noInternetConnection, message: 'No internet connection');
  }

  factory NetworkException.timeout() {
    return const NetworkException(type: NetworkExceptionType.timeout, message: 'Connection timeout');
  }

  factory NetworkException.serverError([String? message]) {
    return NetworkException(
      type: NetworkExceptionType.serverError,
      message: message ?? 'Internal server error',
      statusCode: 500,
    );
  }

  factory NetworkException.badRequest([String? message]) {
    return NetworkException(type: NetworkExceptionType.badRequest, message: message ?? 'Bad request', statusCode: 400);
  }

  factory NetworkException.unauthorized([String? message]) {
    return NetworkException(
      type: NetworkExceptionType.unauthorized,
      message: message ?? 'Unauthorized',
      statusCode: 401,
    );
  }

  factory NetworkException.forbidden([String? message]) {
    return NetworkException(type: NetworkExceptionType.forbidden, message: message ?? 'Forbidden', statusCode: 403);
  }

  factory NetworkException.notFound([String? message]) {
    return NetworkException(type: NetworkExceptionType.notFound, message: message ?? 'Not found', statusCode: 404);
  }

  factory NetworkException.conflict([String? message]) {
    return NetworkException(type: NetworkExceptionType.conflict, message: message ?? 'Conflict', statusCode: 409);
  }

  factory NetworkException.unknown([String? message, dynamic originalException]) {
    return NetworkException(
      type: NetworkExceptionType.unknown,
      message: message ?? 'Unknown error',
      originalException: originalException,
    );
  }

  @override
  String toString() {
    return 'NetworkException: $message (type: $type, statusCode: $statusCode)';
  }
}
