class CustomException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const CustomException({required this.message, this.code, this.stackTrace});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}
