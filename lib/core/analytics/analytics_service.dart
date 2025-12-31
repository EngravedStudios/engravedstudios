import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  Future<void> logScreenView(String screenName);
}

class MockAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    debugPrint("[ANALYTICS] Event: $name, Params: $parameters");
  }

  @override
  Future<void> logScreenView(String screenName) async {
    debugPrint("[ANALYTICS] Screen View: $screenName");
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  // In the future, we can switch this based on environment or flags
  return MockAnalyticsService();
});
