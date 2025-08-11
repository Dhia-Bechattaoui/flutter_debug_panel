import 'package:test/test.dart';
import 'package:flutter_debug_panel/flutter_debug_panel.dart';

void main() {
  group('Simple Example Tests', () {
    test('DebugConfig creation', () {
      const config = DebugConfig(
        enableNetworkLogging: true,
        enableStateInspection: true,
        enablePerformanceMonitoring: true,
        maxNetworkLogs: 10,
        maxPerformanceMetrics: 5,
      );

      expect(config.enableNetworkLogging, isTrue);
      expect(config.enableStateInspection, isTrue);
      expect(config.enablePerformanceMonitoring, isTrue);
      expect(config.maxNetworkLogs, 10);
      expect(config.maxPerformanceMetrics, 5);
    });

    test('NetworkLogger functionality', () {
      final logger = NetworkLogger.instance;
      logger.clearLogs();

      logger.logRequest(
        method: 'GET',
        url: 'https://api.example.com/test',
        headers: {'Content-Type': 'application/json'},
        body: null,
      );

      expect(logger.allLogs.length, 1);
      expect(logger.allLogs.first.method, 'GET');
      expect(logger.allLogs.first.url, 'https://api.example.com/test');
    });

    test('StateInspector functionality', () {
      final inspector = StateInspector.instance;
      inspector.clearStates();

      inspector.captureState('test_key', 'test_value');
      expect(inspector.stateSnapshots['test_key'], 'test_value');
    });

    test('PerformanceMonitor functionality', () {
      final monitor = PerformanceMonitor.instance;
      monitor.clearMetrics();

      monitor.recordMetric(
        name: 'test_metric',
        value: 100.0,
        unit: 'ms',
        description: 'Test metric',
      );

      expect(monitor.allMetrics.length, 1);
      expect(monitor.allMetrics.first.name, 'test_metric');
      expect(monitor.allMetrics.first.value, 100.0);
    });
  });
}
