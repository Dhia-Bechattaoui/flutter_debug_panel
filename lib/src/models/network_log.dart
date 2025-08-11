/// Represents a network request/response log entry
class NetworkLog {
  /// Creates a new NetworkLog instance
  const NetworkLog({
    required this.id,
    required this.method,
    required this.url,
    required this.timestamp,
    required this.duration,
    required this.statusCode,
    required this.requestHeaders,
    required this.responseHeaders,
    required this.requestBody,
    required this.responseBody,
    required this.error,
  });

  /// Unique identifier for the log entry
  final String id;

  /// HTTP method (GET, POST, PUT, DELETE, etc.)
  final String method;

  /// Request URL
  final String url;

  /// Timestamp when the request was made
  final DateTime timestamp;

  /// Duration of the request in milliseconds
  final int duration;

  /// HTTP status code of the response
  final int? statusCode;

  /// Request headers
  final Map<String, String> requestHeaders;

  /// Response headers
  final Map<String, String> responseHeaders;

  /// Request body content
  final String? requestBody;

  /// Response body content
  final String? responseBody;

  /// Error message if the request failed
  final String? error;

  /// Creates a copy of this NetworkLog with the given fields replaced
  NetworkLog copyWith({
    String? id,
    String? method,
    String? url,
    DateTime? timestamp,
    int? duration,
    int? statusCode,
    Map<String, String>? requestHeaders,
    Map<String, String>? responseHeaders,
    String? requestBody,
    String? responseBody,
    String? error,
  }) {
    return NetworkLog(
      id: id ?? this.id,
      method: method ?? this.method,
      url: url ?? this.url,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      statusCode: statusCode ?? this.statusCode,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      requestBody: requestBody ?? this.requestBody,
      responseBody: responseBody ?? this.responseBody,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NetworkLog &&
        other.id == id &&
        other.method == method &&
        other.url == url &&
        other.timestamp == timestamp &&
        other.duration == duration &&
        other.statusCode == statusCode &&
        _mapEquals(other.requestHeaders, requestHeaders) &&
        _mapEquals(other.responseHeaders, responseHeaders) &&
        other.requestBody == requestBody &&
        other.responseBody == responseBody &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      method,
      url,
      timestamp,
      duration,
      statusCode,
      Object.hashAll(requestHeaders.entries),
      Object.hashAll(responseHeaders.entries),
      requestBody,
      responseBody,
      error,
    );
  }

  @override
  String toString() {
    return 'NetworkLog(id: $id, method: $method, url: $url, timestamp: $timestamp, duration: $duration, statusCode: $statusCode)';
  }

  /// Helper method to compare maps
  static bool _mapEquals(Map<String, String>? a, Map<String, String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
