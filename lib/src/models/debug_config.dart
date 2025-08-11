/// Configuration settings for the debug panel
class DebugConfig {
  /// Creates a new DebugConfig instance
  const DebugConfig({
    this.enableNetworkLogging = true,
    this.enableStateInspection = true,
    this.enablePerformanceMonitoring = true,
    this.maxNetworkLogs = 100,
    this.maxPerformanceMetrics = 50,
    this.enableConsoleLogging = true,
    this.enableFileLogging = false,
    this.logLevel = LogLevel.info,
  });

  /// Whether to enable network request/response logging
  final bool enableNetworkLogging;

  /// Whether to enable state inspection functionality
  final bool enableStateInspection;

  /// Whether to enable performance monitoring
  final bool enablePerformanceMonitoring;

  /// Maximum number of network logs to keep in memory
  final int maxNetworkLogs;

  /// Maximum number of performance metrics to keep in memory
  final int maxPerformanceMetrics;

  /// Whether to enable console logging
  final bool enableConsoleLogging;

  /// Whether to enable file logging
  final bool enableFileLogging;

  /// Minimum log level to display
  final LogLevel logLevel;

  /// Creates a copy of this DebugConfig with the given fields replaced
  DebugConfig copyWith({
    bool? enableNetworkLogging,
    bool? enableStateInspection,
    bool? enablePerformanceMonitoring,
    int? maxNetworkLogs,
    int? maxPerformanceMetrics,
    bool? enableConsoleLogging,
    bool? enableFileLogging,
    LogLevel? logLevel,
  }) {
    return DebugConfig(
      enableNetworkLogging: enableNetworkLogging ?? this.enableNetworkLogging,
      enableStateInspection:
          enableStateInspection ?? this.enableStateInspection,
      enablePerformanceMonitoring:
          enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
      maxNetworkLogs: maxNetworkLogs ?? this.maxNetworkLogs,
      maxPerformanceMetrics:
          maxPerformanceMetrics ?? this.maxPerformanceMetrics,
      enableConsoleLogging: enableConsoleLogging ?? this.enableConsoleLogging,
      enableFileLogging: enableFileLogging ?? this.enableFileLogging,
      logLevel: logLevel ?? this.logLevel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DebugConfig &&
        other.enableNetworkLogging == enableNetworkLogging &&
        other.enableStateInspection == enableStateInspection &&
        other.enablePerformanceMonitoring == enablePerformanceMonitoring &&
        other.maxNetworkLogs == maxNetworkLogs &&
        other.maxPerformanceMetrics == maxPerformanceMetrics &&
        other.enableConsoleLogging == enableConsoleLogging &&
        other.enableFileLogging == enableFileLogging &&
        other.logLevel == logLevel;
  }

  @override
  int get hashCode {
    return Object.hash(
      enableNetworkLogging,
      enableStateInspection,
      enablePerformanceMonitoring,
      maxNetworkLogs,
      maxPerformanceMetrics,
      enableConsoleLogging,
      enableFileLogging,
      logLevel,
    );
  }

  @override
  String toString() {
    return 'DebugConfig(enableNetworkLogging: $enableNetworkLogging, enableStateInspection: $enableStateInspection, enablePerformanceMonitoring: $enablePerformanceMonitoring)';
  }
}

/// Log levels for the debug panel
enum LogLevel {
  /// Debug level - most verbose
  debug,

  /// Info level - general information
  info,

  /// Warning level - potential issues
  warning,

  /// Error level - errors that occurred
  error,
}
