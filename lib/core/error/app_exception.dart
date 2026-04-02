class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException(message: $message, cause: $cause)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}
