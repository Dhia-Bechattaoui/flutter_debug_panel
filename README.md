# Flutter Debug Panel

An in-app debug panel for Flutter development with network logs, state inspection, and performance metrics.

[![Pub Version](https://img.shields.io/pub/v/flutter_debug_panel)](https://pub.dev/packages/flutter_debug_panel)
[![Flutter Version](https://img.shields.io/badge/flutter-%3E%3D3.10.0-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg)](https://dart.dev/)

## Features

- **Network Logging**: Intercept and log HTTP requests/responses
- **State Inspection**: Monitor and inspect app state changes
- **Performance Monitoring**: Track performance metrics and execution times
- **In-App Debug Interface**: Beautiful, tabbed debug panel accessible during development
- **Configurable**: Enable/disable features and customize limits
- **Real-time Updates**: Live streams of debug information

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_debug_panel: ^0.0.1
```

### Basic Usage

Wrap your app with the `DebugPanel` widget:

```dart
import 'package:flutter_debug_panel/flutter_debug_panel.dart';

void main() {
  runApp(
    DebugPanel(
      config: const DebugConfig(
        enableNetworkLogging: true,
        enableStateInspection: true,
        enablePerformanceMonitoring: true,
      ),
      child: MyApp(),
    ),
  );
}
```

### Network Logging

The debug panel automatically intercepts HTTP requests when using the `http` package:

```dart
import 'package:http/http.dart' as http;

// This request will be automatically logged
final response = await http.get(Uri.parse('https://api.example.com/data'));
```

### State Inspection

Capture state snapshots for inspection:

```dart
import 'package:flutter_debug_panel/flutter_debug_panel.dart';

// Capture state changes
StateInspector.instance.captureState('user_data', userData);
StateInspector.instance.captureState('app_settings', settings);
```

### Performance Monitoring

Track performance metrics:

```dart
import 'package:flutter_debug_panel/flutter_debug_panel.dart';

// Record custom metrics
PerformanceMonitor.instance.recordMetric(
  name: 'api_call_duration',
  value: 150.0,
  unit: 'ms',
  description: 'API call response time',
);

// Measure function execution time
final result = await PerformanceMonitor.instance.measureExecutionTime(
  () => expensiveOperation(),
  name: 'expensive_operation',
);
```

## Configuration

The `DebugConfig` class allows you to customize the debug panel behavior:

```dart
const config = DebugConfig(
  enableNetworkLogging: true,      // Enable/disable network logging
  enableStateInspection: true,     // Enable/disable state inspection
  enablePerformanceMonitoring: true, // Enable/disable performance monitoring
  maxNetworkLogs: 100,            // Maximum network logs to keep
  maxPerformanceMetrics: 50,      // Maximum performance metrics to keep
  enableConsoleLogging: true,     // Enable console logging
  enableFileLogging: false,       // Enable file logging (future feature)
  logLevel: LogLevel.info,        // Minimum log level to display
);
```

## Debug Panel Interface

The debug panel provides a floating action button that opens a comprehensive debugging interface:

- **Network Tab**: View HTTP requests/responses with status codes, timing, and body content
- **State Tab**: Inspect captured state snapshots and their values
- **Performance Tab**: Monitor performance metrics and execution times

## API Reference

### DebugPanel

The main widget that wraps your app and provides the debug interface.

### NetworkLogger

Singleton class for intercepting and logging network requests:

```dart
// Access the instance
final logger = NetworkLogger.instance;

// Clear logs
logger.clearLogs();

// Get filtered logs
final getRequests = logger.getLogsByMethod('GET');
final errorLogs = logger.getLogsByStatus(500);
```

### StateInspector

Singleton class for state inspection:

```dart
// Access the instance
final inspector = StateInspector.instance;

// Capture state
inspector.captureState('key', value);

// Check for changes
if (inspector.hasStateChanged('key', newValue)) {
  // State has changed
}
```

### PerformanceMonitor

Singleton class for performance monitoring:

```dart
// Access the instance
final monitor = PerformanceMonitor.instance;

// Record metrics
monitor.recordMetric(name: 'memory_usage', value: 45.2, unit: 'MB');

// Measure execution time
final result = await monitor.measureExecutionTime(
  () => asyncOperation(),
  name: 'async_operation',
);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/Dhia-Bechattaoui/flutter_debug_panel/issues).
