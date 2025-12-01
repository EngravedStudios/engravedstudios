import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_logger.dart';

/// Provider for the application logger
final appLoggerProvider = Provider<AppLogger>((ref) => ConsoleLogger());
