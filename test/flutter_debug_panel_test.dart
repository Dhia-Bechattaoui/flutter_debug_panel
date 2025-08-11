import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_debug_panel/flutter_debug_panel.dart';

void main() {
  group('DebugConfig Tests', () {
    test('should create with default values', () {
      const config = DebugConfig();

      expect(config.enableNetworkLogging, isTrue);
      expect(config.enableStateInspection, isTrue);
      expect(config.enablePerformanceMonitoring, isTrue);
      expect(config.maxNetworkLogs, 100);
      expect(config.maxPerformanceMetrics, 50);
      expect(config.enableConsoleLogging, isTrue);
      expect(config.enableFileLogging, isFalse);
      expect(config.logLevel, LogLevel.info);
    });

    test('should create with custom values', () {
      const config = DebugConfig(
        enableNetworkLogging: false,
        enableStateInspection: false,
        enablePerformanceMonitoring: false,
        maxNetworkLogs: 200,
        maxPerformanceMetrics: 100,
        enableConsoleLogging: false,
        enableFileLogging: true,
        logLevel: LogLevel.debug,
      );

      expect(config.enableNetworkLogging, isFalse);
      expect(config.enableStateInspection, isFalse);
      expect(config.enablePerformanceMonitoring, isFalse);
      expect(config.maxNetworkLogs, 200);
      expect(config.maxPerformanceMetrics, 100);
      expect(config.enableConsoleLogging, isFalse);
      expect(config.enableFileLogging, isTrue);
      expect(config.logLevel, LogLevel.debug);
    });

    test('should copy with new values', () {
      const original = DebugConfig();
      final modified = original.copyWith(
        enableNetworkLogging: false,
        maxNetworkLogs: 150,
      );

      expect(modified.enableNetworkLogging, isFalse);
      expect(modified.maxNetworkLogs, 150);
      expect(modified.enableStateInspection, isTrue); // unchanged
      expect(modified.enablePerformanceMonitoring, isTrue); // unchanged
    });

    test('should have proper equality', () {
      const config1 = DebugConfig();
      const config2 = DebugConfig();
      const config3 = DebugConfig(enableNetworkLogging: false);

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });

    test('should have proper hashCode', () {
      const config1 = DebugConfig();
      const config2 = DebugConfig();

      expect(config1.hashCode, equals(config2.hashCode));
    });
  });

  group('NetworkLog Tests', () {
    test('should create with required parameters', () {
      final log = NetworkLog(
        id: 'test-id',
        method: 'GET',
        url: 'https://example.com',
        timestamp: DateTime(2024, 1, 1),
        duration: 100,
        statusCode: 200,
        requestHeaders: {'Content-Type': 'application/json'},
        responseHeaders: {'Content-Length': '100'},
        requestBody: '{"test": "data"}',
        responseBody: '{"result": "success"}',
        error: null,
      );

      expect(log.id, 'test-id');
      expect(log.method, 'GET');
      expect(log.url, 'https://example.com');
      expect(log.duration, 100);
      expect(log.statusCode, 200);
      expect(log.requestHeaders['Content-Type'], 'application/json');
      expect(log.responseHeaders['Content-Length'], '100');
      expect(log.requestBody, '{"test": "data"}');
      expect(log.responseBody, '{"result": "success"}');
      expect(log.error, isNull);
    });

    test('should copy with new values', () {
      final original = NetworkLog(
        id: 'test-id',
        method: 'GET',
        url: 'https://example.com',
        timestamp: DateTime(2024, 1, 1),
        duration: 100,
        statusCode: 200,
        requestHeaders: {},
        responseHeaders: {},
        requestBody: null,
        responseBody: null,
        error: null,
      );

      final modified = original.copyWith(statusCode: 404, error: 'Not found');

      expect(modified.statusCode, 404);
      expect(modified.error, 'Not found');
      expect(modified.method, 'GET'); // unchanged
      expect(modified.url, 'https://example.com'); // unchanged
    });

    test('should have proper equality', () {
      final log1 = NetworkLog(
        id: 'test-id',
        method: 'GET',
        url: 'https://example.com',
        timestamp: DateTime(2024, 1, 1),
        duration: 100,
        statusCode: 200,
        requestHeaders: {'key': 'value'},
        responseHeaders: {},
        requestBody: null,
        responseBody: null,
        error: null,
      );

      final log2 = NetworkLog(
        id: 'test-id',
        method: 'GET',
        url: 'https://example.com',
        timestamp: DateTime(2024, 1, 1),
        duration: 100,
        statusCode: 200,
        requestHeaders: {'key': 'value'},
        responseHeaders: {},
        requestBody: null,
        responseBody: null,
        error: null,
      );

      expect(log1, equals(log2));
    });
  });

  group('PerformanceMetric Tests', () {
    test('should create with required parameters', () {
      final metric = PerformanceMetric(
        id: 'test-id',
        name: 'execution_time',
        value: 150.5,
        unit: 'ms',
        timestamp: DateTime(2024, 1, 1),
        description: 'Test execution time',
        tags: {'test': 'true'},
      );

      expect(metric.id, 'test-id');
      expect(metric.name, 'execution_time');
      expect(metric.value, 150.5);
      expect(metric.unit, 'ms');
      expect(metric.description, 'Test execution time');
      expect(metric.tags['test'], 'true');
    });

    test('should copy with new values', () {
      final original = PerformanceMetric(
        id: 'test-id',
        name: 'execution_time',
        value: 150.5,
        unit: 'ms',
        timestamp: DateTime(2024, 1, 1),
        description: 'Test execution time',
        tags: {'test': 'true'},
      );

      final modified = original.copyWith(
        value: 200.0,
        description: 'Updated description',
      );

      expect(modified.value, 200.0);
      expect(modified.description, 'Updated description');
      expect(modified.name, 'execution_time'); // unchanged
      expect(modified.unit, 'ms'); // unchanged
    });
  });

  group('StateChange Tests', () {
    test('should create with required parameters', () {
      final change = StateChange(
        key: 'test_key',
        previousState: 'old_value',
        currentState: 'new_value',
        timestamp: DateTime(2024, 1, 1),
      );

      expect(change.key, 'test_key');
      expect(change.previousState, 'old_value');
      expect(change.currentState, 'new_value');
      expect(change.timestamp, DateTime(2024, 1, 1));
    });

    test('should have proper toString', () {
      final change = StateChange(
        key: 'test_key',
        previousState: 'old_value',
        currentState: 'new_value',
        timestamp: DateTime(2024, 1, 1),
      );

      expect(change.toString(), contains('test_key'));
      expect(change.toString(), contains('StateChange'));
    });
  });
}
