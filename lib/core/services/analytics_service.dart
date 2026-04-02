import '../utils/app_logger.dart';

abstract interface class AnalyticsService {
  Future<void> trackEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  });
}

class ConsoleAnalyticsService implements AnalyticsService {
  @override
  Future<void> trackEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  }) async {
    AppLogger.info('Analytics event: $name | $parameters');
  }
}
