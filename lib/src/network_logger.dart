import 'dart:async';
import 'models/network_log.dart';

/// Intercepts and logs HTTP requests and responses
class NetworkLogger {
  NetworkLogger._();

  static final NetworkLogger _instance = NetworkLogger._();

  /// The singleton instance of [NetworkLogger].
  ///
  /// Use this to access the network logger functionality:
  /// ```dart
  /// final logger = NetworkLogger.instance;
  /// logger.logRequest(method: 'GET', url: 'https://api.example.com', headers: {});
  /// ```
  static NetworkLogger get instance => _instance;

  final List<NetworkLog> _logs = [];
  final StreamController<NetworkLog> _logController =
      StreamController<NetworkLog>.broadcast();

  /// Stream of network logs
  Stream<NetworkLog> get logs => _logController.stream;

  /// List of all network logs
  List<NetworkLog> get allLogs => List.unmodifiable(_logs);

  /// Maximum number of logs to keep in memory
  int _maxLogs = 100;

  /// Set the maximum number of logs to keep
  void setMaxLogs(int maxLogs) {
    _maxLogs = maxLogs;
    _trimLogs();
  }

  /// Clear all network logs
  void clearLogs() {
    _logs.clear();
  }

  /// Get logs filtered by HTTP method
  List<NetworkLog> getLogsByMethod(String method) {
    return _logs
        .where((log) => log.method.toUpperCase() == method.toUpperCase())
        .toList();
  }

  /// Get logs filtered by status code
  List<NetworkLog> getLogsByStatus(int statusCode) {
    return _logs.where((log) => log.statusCode == statusCode).toList();
  }

  /// Get logs filtered by URL pattern
  List<NetworkLog> getLogsByUrl(String urlPattern) {
    return _logs.where((log) => log.url.contains(urlPattern)).toList();
  }

  /// Log a network request
  String logRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) {
    final log = NetworkLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      method: method,
      url: url,
      timestamp: DateTime.now(),
      duration: 0,
      statusCode: null,
      requestHeaders: headers,
      responseHeaders: {},
      requestBody: body,
      responseBody: null,
      error: null,
    );

    _addLog(log);
    return log.id;
  }

  /// Log a network response
  void logResponse({
    required String method,
    required String url,
    required int statusCode,
    required Map<String, String> headers,
    String? body,
    int? duration,
    String? error,
    String? requestId, // Optional request ID for better matching
  }) {
    final existingLogIndex = _logs.indexWhere(
      (log) =>
          (requestId != null && log.id == requestId) ||
          (log.method == method && log.url == url && log.statusCode == null),
    );

    if (existingLogIndex != -1) {
      final existingLog = _logs[existingLogIndex];
      final updatedLog = existingLog.copyWith(
        statusCode: statusCode,
        responseHeaders: headers,
        responseBody: body,
        duration: duration ?? 0,
        error: error,
      );
      _logs[existingLogIndex] = updatedLog;
      _logController.add(updatedLog);
    } else {
      final log = NetworkLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        method: method,
        url: url,
        timestamp: DateTime.now(),
        duration: duration ?? 0,
        statusCode: statusCode,
        requestHeaders: {}, // Note: request headers not available when creating response-only log
        responseHeaders: headers,
        requestBody: null,
        responseBody: body,
        error: error,
      );
      _addLog(log);
    }
  }

  void _addLog(NetworkLog log) {
    _logs.add(log);
    _trimLogs();
    _logController.add(log);
  }

  void _trimLogs() {
    if (_logs.length > _maxLogs) {
      _logs.removeRange(0, _logs.length - _maxLogs);
    }
  }

  /// Dispose the logger
  void dispose() {
    _logController.close();
  }
}
