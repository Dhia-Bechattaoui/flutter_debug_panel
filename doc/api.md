# Flutter Debug Panel API Documentation

## Overview

The Flutter Debug Panel provides a comprehensive debugging toolkit for Flutter applications. It includes network logging, state inspection, and performance monitoring capabilities.

## Core Classes

### DebugPanel

The main widget that wraps your app and provides the debug interface.

#### Constructor

```dart
const DebugPanel({
  Key? key,
  DebugConfig config = const DebugConfig(),
  Widget? child,
})
```

#### Properties

- `config` - Configuration settings for the debug panel
- `child` - The widget to wrap with the debug panel

#### Usage

```dart
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

### DebugConfig

Configuration class for customizing the debug panel behavior.

#### Constructor

```dart
const DebugConfig({
  bool enableNetworkLogging = true,
  bool enableStateInspection = true,
  bool enablePerformanceMonitoring = true,
  int maxNetworkLogs = 100,
  int maxPerformanceMetrics = 50,
  bool enableConsoleLogging = true,
  bool enableFileLogging = false,
  LogLevel logLevel = LogLevel.info,
})
```

#### Properties

- `enableNetworkLogging` - Enable/disable network request logging
- `enableStateInspection` - Enable/disable state inspection
- `enablePerformanceMonitoring` - Enable/disable performance monitoring
- `maxNetworkLogs` - Maximum number of network logs to keep in memory
- `maxPerformanceMetrics` - Maximum number of performance metrics to keep
- `enableConsoleLogging` - Enable console logging output
- `enableFileLogging` - Enable file logging (future feature)
- `logLevel` - Minimum log level to display

#### Methods

- `copyWith({...})` - Create a copy with modified values

### NetworkLogger

Singleton class for intercepting and logging network requests and responses.

#### Access

```dart
final logger = NetworkLogger.instance;
```

#### Methods

##### `logRequest({required String method, required String url, required Map<String, String> headers, String? body})`

Log a network request.

**Parameters:**
- `method` - HTTP method (GET, POST, PUT, DELETE, etc.)
- `url` - Request URL
- `headers` - Request headers
- `body` - Request body content

**Example:**
```dart
NetworkLogger.instance.logRequest(
  method: 'POST',
  url: 'https://api.example.com/users',
  headers: {'Content-Type': 'application/json'},
  body: '{"name": "John Doe"}',
);
```

##### `logResponse({required String method, required String url, required int statusCode, required Map<String, String> headers, String? body, int? duration, String? error})`

Log a network response.

**Parameters:**
- `method` - HTTP method
- `url` - Request URL
- `statusCode` - HTTP status code
- `headers` - Response headers
- `body` - Response body content
- `duration` - Request duration in milliseconds
- `error` - Error message if request failed

**Example:**
```dart
NetworkLogger.instance.logResponse(
  method: 'POST',
  url: 'https://api.example.com/users',
  statusCode: 201,
  headers: {'Content-Length': '128'},
  body: '{"id": 1, "name": "John Doe"}',
  duration: 150,
);
```

##### `clearLogs()`

Clear all network logs.

##### `getLogsByMethod(String method)`

Get logs filtered by HTTP method.

**Returns:** List of NetworkLog objects

##### `getLogsByStatus(int statusCode)`

Get logs filtered by HTTP status code.

**Returns:** List of NetworkLog objects

##### `getLogsByUrl(String urlPattern)`

Get logs filtered by URL pattern.

**Returns:** List of NetworkLog objects

#### Properties

- `logs` - Stream of network logs
- `allLogs` - List of all network logs

### StateInspector

Singleton class for inspecting and monitoring state changes.

#### Access

```dart
final inspector = StateInspector.instance;
```

#### Methods

##### `captureState(String key, dynamic state)`

Capture a snapshot of the current state.

**Parameters:**
- `key` - Unique identifier for the state
- `state` - State value to capture

**Example:**
```dart
StateInspector.instance.captureState('user_data', userData);
StateInspector.instance.captureState('app_settings', settings);
```

##### `getState(String key)`

Get the current state for a given key.

**Returns:** The state value or null if not found

##### `hasStateChanged(String key, dynamic newState)`

Check if state has changed for a given key.

**Returns:** true if state has changed, false otherwise

##### `clearStates()`

Clear all state snapshots.

#### Properties

- `changes` - Stream of state changes
- `stateSnapshots` - Map of all state snapshots

### PerformanceMonitor

Singleton class for monitoring performance metrics.

#### Access

```dart
final monitor = PerformanceMonitor.instance;
```

#### Methods

##### `recordMetric({required String name, required double value, required String unit, String? description, Map<String, String>? tags})`

Record a performance metric.

**Parameters:**
- `name` - Name of the metric
- `value` - Numeric value of the metric
- `unit` - Unit of measurement (ms, MB, %, etc.)
- `description` - Optional description
- `tags` - Optional tags for categorization

**Example:**
```dart
PerformanceMonitor.instance.recordMetric(
  name: 'api_call_duration',
  value: 150.0,
  unit: 'ms',
  description: 'API call response time',
  tags: {'endpoint': 'users'},
);
```

##### `measureExecutionTime<T>(Future<T> Function() function, {String? name, Map<String, String>? tags})`

Measure the execution time of an async function.

**Parameters:**
- `function` - The function to measure
- `name` - Optional metric name (defaults to 'execution_time')
- `tags` - Optional tags

**Returns:** The result of the function execution

**Example:**
```dart
final result = await PerformanceMonitor.instance.measureExecutionTime(
  () => expensiveOperation(),
  name: 'expensive_operation',
  tags: {'component': 'data_processing'},
);
```

##### `recordMemoryUsage({String? description, Map<String, String>? tags})`

Record memory usage metric.

##### `recordFrameRate({double fps = 60.0, String? description, Map<String, String>? tags})`

Record frame rate metric.

##### `getMetricsByName(String name)`

Get metrics filtered by name.

**Returns:** List of PerformanceMetric objects

##### `getMetricsByTag(String tagKey, String tagValue)`

Get metrics filtered by tag.

**Returns:** List of PerformanceMetric objects

##### `getAverageMetricValue(String name)`

Get average value for a specific metric.

**Returns:** Average value or 0.0 if no metrics found

##### `getLatestMetric(String name)`

Get the latest metric for a specific name.

**Returns:** Latest PerformanceMetric or null if not found

##### `clearMetrics()`

Clear all performance metrics.

#### Properties

- `metrics` - Stream of performance metrics
- `allMetrics` - List of all performance metrics

## Data Models

### NetworkLog

Represents a network request/response log entry.

#### Properties

- `id` - Unique identifier
- `method` - HTTP method
- `url` - Request URL
- `timestamp` - Timestamp when request was made
- `duration` - Request duration in milliseconds
- `statusCode` - HTTP status code
- `requestHeaders` - Request headers
- `responseHeaders` - Response headers
- `requestBody` - Request body content
- `responseBody` - Response body content
- `error` - Error message if request failed

#### Methods

- `copyWith({...})` - Create a copy with modified values

### PerformanceMetric

Represents a performance metric measurement.

#### Properties

- `id` - Unique identifier
- `name` - Metric name
- `value` - Numeric value
- `unit` - Unit of measurement
- `timestamp` - When metric was recorded
- `description` - Optional description
- `tags` - Optional categorization tags

#### Methods

- `copyWith({...})` - Create a copy with modified values

### StateChange

Represents a state change event.

#### Properties

- `key` - State key
- `previousState` - Previous state value
- `currentState` - Current state value
- `timestamp` - When change occurred

## Log Levels

### LogLevel Enum

- `debug` - Debug level (most verbose)
- `info` - Info level (general information)
- `warning` - Warning level (potential issues)
- `error` - Error level (errors that occurred)

## Best Practices

### 1. Configuration

Configure the debug panel based on your development needs:

```dart
const config = DebugConfig(
  enableNetworkLogging: true,      // Enable for API debugging
  enableStateInspection: true,     // Enable for state debugging
  enablePerformanceMonitoring: true, // Enable for performance debugging
  maxNetworkLogs: 50,             // Adjust based on memory constraints
  maxPerformanceMetrics: 25,      // Adjust based on memory constraints
  logLevel: LogLevel.info,        // Set appropriate log level
);
```

### 2. Network Logging

Log network requests and responses consistently:

```dart
// Log request
NetworkLogger.instance.logRequest(
  method: 'POST',
  url: 'https://api.example.com/users',
  headers: {'Authorization': 'Bearer $token'},
  body: jsonEncode(userData),
);

// Log response
NetworkLogger.instance.logResponse(
  method: 'POST',
  url: 'https://api.example.com/users',
  statusCode: response.statusCode,
  headers: response.headers,
  body: response.body,
  duration: stopwatch.elapsedMilliseconds,
);
```

### 3. State Inspection

Capture state changes at key points:

```dart
// Capture initial state
StateInspector.instance.captureState('user_data', userData);

// Capture state changes
StateInspector.instance.captureState('user_data', updatedUserData);

// Check for changes before updating
if (StateInspector.instance.hasStateChanged('user_data', newUserData)) {
  // State has changed, update UI
}
```

### 4. Performance Monitoring

Monitor key performance metrics:

```dart
// Record custom metrics
PerformanceMonitor.instance.recordMetric(
  name: 'page_load_time',
  value: pageLoadTime,
  unit: 'ms',
  description: 'Time to load page',
);

// Measure function execution
final result = await PerformanceMonitor.instance.measureExecutionTime(
  () => expensiveOperation(),
  name: 'expensive_operation',
);
```

### 5. Memory Management

Dispose of resources when no longer needed:

```dart
@override
void dispose() {
  NetworkLogger.instance.dispose();
  StateInspector.instance.dispose();
  PerformanceMonitor.instance.dispose();
  super.dispose();
}
```

## Error Handling

The debug panel is designed to be non-intrusive. If any errors occur in the debugging functionality, they won't affect your main application. However, it's good practice to handle potential errors:

```dart
try {
  NetworkLogger.instance.logRequest(
    method: 'GET',
    url: 'https://api.example.com/data',
    headers: {},
    body: null,
  );
} catch (e) {
  // Log error but don't crash the app
  print('Debug panel error: $e');
}
```

## Platform Considerations

- **Web**: All features work as expected
- **iOS/Android**: All features work as expected
- **Desktop**: All features work as expected
- **Linux**: All features work as expected

## Performance Impact

The debug panel is designed to have minimal performance impact:

- Network logging adds minimal overhead to HTTP requests
- State inspection uses efficient deep comparison
- Performance monitoring uses lightweight measurement
- All data is stored in memory for fast access
- Automatic cleanup prevents memory leaks

## Troubleshooting

### Common Issues

1. **Debug panel not visible**: Ensure the DebugPanel widget is properly wrapped around your app
2. **Network logs not appearing**: Check that network logging is enabled in the configuration
3. **State changes not detected**: Verify that state inspection is enabled and states are being captured
4. **Performance metrics missing**: Ensure performance monitoring is enabled and metrics are being recorded

### Debug Mode

The debug panel automatically detects debug mode and may provide additional information when running in debug builds.

## Migration Guide

### From Previous Versions

If you're upgrading from a previous version:

1. Update your dependencies
2. Review any deprecated API usage
3. Test the new functionality
4. Update your configuration if needed

## Support

For issues, questions, or contributions:

- GitHub Issues: [https://github.com/Dhia-Bechattaoui/flutter_debug_panel/issues](https://github.com/Dhia-Bechattaoui/flutter_debug_panel/issues)
- Documentation: [https://github.com/Dhia-Bechattaoui/flutter_debug_panel#readme](https://github.com/Dhia-Bechattaoui/flutter_debug_panel#readme)
