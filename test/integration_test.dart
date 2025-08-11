import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_debug_panel/flutter_debug_panel.dart';

void main() {
  group('Integration Tests', () {
    test('NetworkLogger singleton pattern', () {
      final logger1 = NetworkLogger.instance;
      final logger2 = NetworkLogger.instance;

      expect(logger1, same(logger2));
    });

    test('StateInspector singleton pattern', () {
      final inspector1 = StateInspector.instance;
      final inspector2 = StateInspector.instance;

      expect(inspector1, same(inspector2));
    });

    test('PerformanceMonitor singleton pattern', () {
      final monitor1 = PerformanceMonitor.instance;
      final monitor2 = PerformanceMonitor.instance;

      expect(monitor1, same(monitor2));
    });

    test('NetworkLogger basic functionality', () {
      final logger = NetworkLogger.instance;
      logger.clearLogs();

      // Log a request
      logger.logRequest(
        method: 'GET',
        url: 'https://example.com',
        headers: {'Content-Type': 'application/json'},
        body: '{"test": "data"}',
      );

      expect(logger.allLogs.length, 1);
      expect(logger.allLogs.first.method, 'GET');
      expect(logger.allLogs.first.url, 'https://example.com');

      // Log a response
      logger.logResponse(
        method: 'GET',
        url: 'https://example.com',
        statusCode: 200,
        headers: {'Content-Length': '100'},
        body: '{"result": "success"}',
        duration: 150,
      );

      expect(logger.allLogs.length, 1); // Should update existing log
      expect(logger.allLogs.first.statusCode, 200);
      expect(logger.allLogs.first.duration, 150);
    });

    test('StateInspector basic functionality', () {
      final inspector = StateInspector.instance;
      inspector.clearStates();

      // Capture initial state
      inspector.captureState('test_key', 'initial_value');
      expect(inspector.stateSnapshots['test_key'], 'initial_value');

      // Capture updated state
      inspector.captureState('test_key', 'updated_value');
      expect(inspector.stateSnapshots['test_key'], 'updated_value');

      // Check state change detection
      expect(inspector.hasStateChanged('test_key', 'updated_value'), false);
      expect(inspector.hasStateChanged('test_key', 'new_value'), true);
    });

    test('PerformanceMonitor basic functionality', () {
      final monitor = PerformanceMonitor.instance;
      monitor.clearMetrics();

      // Record a metric
      monitor.recordMetric(
        name: 'test_metric',
        value: 100.0,
        unit: 'ms',
        description: 'Test metric',
      );

      expect(monitor.allMetrics.length, 1);
      expect(monitor.allMetrics.first.name, 'test_metric');
      expect(monitor.allMetrics.first.value, 100.0);

      // Test filtering
      final metrics = monitor.getMetricsByName('test_metric');
      expect(metrics.length, 1);
      expect(metrics.first.value, 100.0);
    });

    test('DebugConfig validation', () {
      const config = DebugConfig(
        enableNetworkLogging: false,
        enableStateInspection: false,
        enablePerformanceMonitoring: false,
        maxNetworkLogs: 50,
        maxPerformanceMetrics: 25,
      );

      expect(config.enableNetworkLogging, false);
      expect(config.enableStateInspection, false);
      expect(config.enablePerformanceMonitoring, false);
      expect(config.maxNetworkLogs, 50);
      expect(config.maxPerformanceMetrics, 25);
    });

    test('LogLevel enum values', () {
      expect(LogLevel.debug.index, 0);
      expect(LogLevel.info.index, 1);
      expect(LogLevel.warning.index, 2);
      expect(LogLevel.error.index, 3);
    });
  });
}
