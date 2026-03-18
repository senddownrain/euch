class AppException implements Exception {
  AppException(this.message, [this.details]);

  final String message;
  final Object? details;

  @override
  String toString() => 'AppException(message: $message, details: $details)';
}
