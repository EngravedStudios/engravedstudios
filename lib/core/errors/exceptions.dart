/// Custom exceptions for the application
class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: $message ${code != null ? '($code)' : ''}';
}

class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

class CacheException extends AppException {
  CacheException(super.message, [super.code]);
}

class ValidationException extends AppException {
  ValidationException(super.message, [super.code]);
}
