/// Represents a performance metric measurement
class PerformanceMetric {
  /// Creates a new PerformanceMetric instance
  const PerformanceMetric({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.description,
    this.tags = const {},
  });

  /// Unique identifier for the metric
  final String id;

  /// Name of the metric
  final String name;

  /// Numeric value of the metric
  final double value;

  /// Unit of measurement (ms, MB, %, etc.)
  final String unit;

  /// Timestamp when the metric was recorded
  final DateTime timestamp;

  /// Optional description of the metric
  final String? description;

  /// Optional tags for categorizing the metric
  final Map<String, String> tags;

  /// Creates a copy of this PerformanceMetric with the given fields replaced
  PerformanceMetric copyWith({
    String? id,
    String? name,
    double? value,
    String? unit,
    DateTime? timestamp,
    String? description,
    Map<String, String>? tags,
  }) {
    return PerformanceMetric(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PerformanceMetric &&
        other.id == id &&
        other.name == name &&
        other.value == value &&
        other.unit == unit &&
        other.timestamp == timestamp &&
        other.description == description &&
        other.tags.length == tags.length &&
        other.tags.entries.every((e) => tags[e.key] == e.value);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      value,
      unit,
      timestamp,
      description,
      Object.hashAll(tags.entries),
    );
  }

  @override
  String toString() {
    return 'PerformanceMetric(id: $id, name: $name, value: $value, unit: $unit, timestamp: $timestamp)';
  }
}
