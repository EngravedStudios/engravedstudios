/// Generic Result type for error handling
/// Manual implementation to avoid build_runner dependency for now
class Result<T> {
  final T? _data;
  final Failure? _failure;

  const Result._(this._data, this._failure);

  factory Result.success(T data) => Result._(data, null);
  factory Result.failure(Failure failure) => Result._(null, failure);

  bool get isSuccess => _failure == null;
  bool get isFailure => _failure != null;

  T get data {
    if (_failure != null) throw Exception('Cannot get data from failure result');
    return _data!;
  }

  Failure get failure {
    if (_failure == null) throw Exception('Cannot get failure from success result');
    return _failure;
  }

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    if (isFailure) {
      return onFailure(_failure!);
    } else {
      return onSuccess(_data as T);
    }
  }
}

/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final String? code;
  
  const Failure(this.message, [this.code]);
  
  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Server/API related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

/// Cache/local storage failures
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.code]);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}
