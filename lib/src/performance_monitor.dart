import 'dart:async';
import 'models/performance_metric.dart';

/// Monitors and tracks performance metrics in the app
class PerformanceMonitor {
  PerformanceMonitor._();

  static final PerformanceMonitor _instance = PerformanceMonitor._();
  static PerformanceMonitor get instance => _instance;

  final List<PerformanceMetric> _metrics = [];
  final StreamController<PerformanceMetric> _metricController =
      StreamController<PerformanceMetric>.broadcast();

  /// Stream of performance metrics
  Stream<PerformanceMetric> get metrics => _metricController.stream;

  /// List of all performance metrics
  List<PerformanceMetric> get allMetrics => List.unmodifiable(_metrics);

  /// Maximum number of metrics to keep in memory
  int _maxMetrics = 50;

  /// Set the maximum number of metrics to keep
  void setMaxMetrics(int maxMetrics) {
    _maxMetrics = maxMetrics;
    _trimMetrics();
  }

  /// Record a performance metric
  void recordMetric({
    required String name,
    required double value,
    required String unit,
    String? description,
    Map<String, String>? tags,
  }) {
    final metric = PerformanceMetric(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      value: value,
      unit: unit,
      timestamp: DateTime.now(),
      description: description,
      tags: tags ?? {},
    );

    _addMetric(metric);
  }

  /// Record execution time of a function
  Future<T> measureExecutionTime<T>(
    Future<T> Function() function, {
    String? name,
    Map<String, String>? tags,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();

      recordMetric(
        name: name ?? 'execution_time',
        value:
            stopwatch.elapsedMicroseconds / 1000.0, // Convert to milliseconds
        unit: 'ms',
        description: 'Function execution time',
        tags: tags,
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      recordMetric(
        name: name ?? 'execution_time',
        value: stopwatch.elapsedMicroseconds / 1000.0,
        unit: 'ms',
        description: 'Function execution time (with error)',
        tags: {...?tags, 'error': 'true'},
      );
      rethrow;
    }
  }

  /// Record memory usage
  void recordMemoryUsage({String? description, Map<String, String>? tags}) {
    // This is a placeholder - actual memory measurement would require platform-specific code
    recordMetric(
      name: 'memory_usage',
      value: 0.0, // Placeholder value
      unit: 'MB',
      description: description ?? 'Memory usage',
      tags: tags,
    );
  }

  /// Record frame rate
  void recordFrameRate({
    double fps = 60.0,
    String? description,
    Map<String, String>? tags,
  }) {
    recordMetric(
      name: 'frame_rate',
      value: fps,
      unit: 'fps',
      description: description ?? 'Current frame rate',
      tags: tags,
    );
  }

  /// Get metrics by name
  List<PerformanceMetric> getMetricsByName(String name) {
    return _metrics.where((metric) => metric.name == name).toList();
  }

  /// Get metrics by tag
  List<PerformanceMetric> getMetricsByTag(String tagKey, String tagValue) {
    return _metrics.where((metric) => metric.tags[tagKey] == tagValue).toList();
  }

  /// Get average value for a specific metric
  double getAverageMetricValue(String name) {
    final metrics = getMetricsByName(name);
    if (metrics.isEmpty) return 0.0;

    final sum = metrics.fold(0.0, (sum, metric) => sum + metric.value);
    return sum / metrics.length;
  }

  /// Get the latest metric for a specific name
  PerformanceMetric? getLatestMetric(String name) {
    final metrics = getMetricsByName(name);
    if (metrics.isEmpty) return null;

    metrics.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return metrics.first;
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
  }

  void _addMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    _trimMetrics();
    _metricController.add(metric);
  }

  void _trimMetrics() {
    if (_metrics.length > _maxMetrics) {
      _metrics.removeRange(0, _metrics.length - _maxMetrics);
    }
  }

  /// Dispose the monitor
  void dispose() {
    _metricController.close();
  }
}
