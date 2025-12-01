import 'package:logger/logger.dart';

/// Abstract logging interface for dependency injection
abstract class AppLogger {
  void debug(String message, [dynamic error, StackTrace? stackTrace]);
  void info(String message);
  void warning(String message, [dynamic error]);
  void error(String message, dynamic error, [StackTrace? stackTrace]);
}

/// Console implementation of AppLogger using the logger package
class ConsoleLogger implements AppLogger {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, dynamic error, [StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message) => _logger.i(message);

  @override
  void warning(String message, [dynamic error]) {
    _logger.w(message, error: error);
  }
}
