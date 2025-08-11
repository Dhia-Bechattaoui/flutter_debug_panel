import 'package:flutter_debug_panel/flutter_debug_panel.dart';

/// Simple example demonstrating the debug panel functionality
class SimpleExample {
  /// Run the example
  static void run() {
    print('=== Flutter Debug Panel Example ===\n');

    // Initialize debug configuration
    const config = DebugConfig(
      enableNetworkLogging: true,
      enableStateInspection: true,
      enablePerformanceMonitoring: true,
      maxNetworkLogs: 10,
      maxPerformanceMetrics: 5,
    );

    print('Debug configuration:');
    print('- Network logging: ${config.enableNetworkLogging}');
    print('- State inspection: ${config.enableStateInspection}');
    print('- Performance monitoring: ${config.enablePerformanceMonitoring}');
    print('- Max network logs: ${config.maxNetworkLogs}');
    print('- Max performance metrics: ${config.maxPerformanceMetrics}\n');

    // Demonstrate network logging
    print('=== Network Logging ===');
    final networkLogger = NetworkLogger.instance;
    networkLogger.clearLogs();

    // Log some requests
    networkLogger.logRequest(
      method: 'GET',
      url: 'https://api.example.com/users',
      headers: {'Authorization': 'Bearer token123'},
      body: null,
    );

    networkLogger.logRequest(
      method: 'POST',
      url: 'https://api.example.com/users',
      headers: {'Content-Type': 'application/json'},
      body: '{"name": "John Doe", "email": "john@example.com"}',
    );

    // Log responses
    networkLogger.logResponse(
      method: 'GET',
      url: 'https://api.example.com/users',
      statusCode: 200,
      headers: {'Content-Length': '1024'},
      body: '[{"id": 1, "name": "John Doe"}]',
      duration: 150,
    );

    networkLogger.logResponse(
      method: 'POST',
      url: 'https://api.example.com/users',
      statusCode: 201,
      headers: {'Content-Length': '128'},
      body: '{"id": 2, "name": "John Doe", "email": "john@example.com"}',
      duration: 200,
    );

    print('Network logs created: ${networkLogger.allLogs.length}');
    print('GET requests: ${networkLogger.getLogsByMethod('GET').length}');
    print('POST requests: ${networkLogger.getLogsByMethod('POST').length}');
    print('Successful requests: ${networkLogger.getLogsByStatus(200).length}');
    print('Created requests: ${networkLogger.getLogsByStatus(201).length}\n');

    // Demonstrate state inspection
    print('=== State Inspection ===');
    final stateInspector = StateInspector.instance;
    stateInspector.clearStates();

    // Capture some state
    stateInspector.captureState('user_id', 123);
    stateInspector.captureState('user_name', 'John Doe');
    stateInspector.captureState('is_authenticated', true);
    stateInspector.captureState('preferences', {
      'theme': 'dark',
      'language': 'en',
      'notifications': true,
    });

    // Update some state
    stateInspector.captureState('user_id', 456);
    stateInspector.captureState('preferences', {
      'theme': 'light',
      'language': 'en',
      'notifications': false,
    });

    print('State snapshots captured: ${stateInspector.stateSnapshots.length}');
    print('User ID: ${stateInspector.getState('user_id')}');
    print('User name: ${stateInspector.getState('user_name')}');
    print('Is authenticated: ${stateInspector.getState('is_authenticated')}');
    print('Preferences: ${stateInspector.getState('preferences')}\n');

    // Demonstrate performance monitoring
    print('=== Performance Monitoring ===');
    final performanceMonitor = PerformanceMonitor.instance;
    performanceMonitor.clearMetrics();

    // Record some metrics
    performanceMonitor.recordMetric(
      name: 'app_startup_time',
      value: 1250.5,
      unit: 'ms',
      description: 'Time taken for app to start',
    );

    performanceMonitor.recordMetric(
      name: 'memory_usage',
      value: 45.2,
      unit: 'MB',
      description: 'Current memory usage',
      tags: {'component': 'main_app'},
    );

    performanceMonitor.recordMetric(
      name: 'api_response_time',
      value: 150.0,
      unit: 'ms',
      description: 'Average API response time',
      tags: {'endpoint': 'users'},
    );

    print(
        'Performance metrics recorded: ${performanceMonitor.allMetrics.length}');
    print(
        'App startup time: ${performanceMonitor.getLatestMetric('app_startup_time')?.value} ms');
    print(
        'Memory usage: ${performanceMonitor.getLatestMetric('memory_usage')?.value} MB');
    print(
        'API response time: ${performanceMonitor.getLatestMetric('api_response_time')?.value} ms');

    // Calculate averages
    print('\n=== Summary ===');
    print('Total network requests: ${networkLogger.allLogs.length}');
    print('Total state snapshots: ${stateInspector.stateSnapshots.length}');
    print('Total performance metrics: ${performanceMonitor.allMetrics.length}');
    print(
        'Average API response time: ${performanceMonitor.getAverageMetricValue('api_response_time').toStringAsFixed(2)} ms');

    print('\n=== Example Complete ===');
    print('The debug panel is now ready to use in your Flutter app!');
  }
}

/// Main function to run the example
void main() {
  SimpleExample.run();
}
