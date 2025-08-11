import 'dart:async';
import 'dart:convert';

/// Inspects and monitors state changes in the app
class StateInspector {
  StateInspector._();

  static final StateInspector _instance = StateInspector._();
  static StateInspector get instance => _instance;

  final Map<String, dynamic> _stateSnapshots = {};
  final StreamController<StateChange> _changeController =
      StreamController<StateChange>.broadcast();

  /// Stream of state changes
  Stream<StateChange> get changes => _changeController.stream;

  /// Map of all state snapshots
  Map<String, dynamic> get stateSnapshots => Map.unmodifiable(_stateSnapshots);

  /// Capture a snapshot of the current state
  void captureState(String key, dynamic state) {
    final previousState = _stateSnapshots[key];
    _stateSnapshots[key] = _deepCopy(state);

    if (previousState != null) {
      final change = StateChange(
        key: key,
        previousState: previousState,
        currentState: _deepCopy(state),
        timestamp: DateTime.now(),
      );
      _changeController.add(change);
    }
  }

  /// Get the current state for a given key
  dynamic getState(String key) {
    return _stateSnapshots[key];
  }

  /// Check if state has changed for a given key
  bool hasStateChanged(String key, dynamic newState) {
    final currentState = _stateSnapshots[key];
    if (currentState == null) return true;
    return !_deepEquals(currentState, newState);
  }

  /// Clear all state snapshots
  void clearStates() {
    _stateSnapshots.clear();
  }

  /// Get state changes for a specific key
  List<StateChange> getChangesForKey(String key) {
    // This would need to be implemented with a proper change history
    // For now, return empty list
    return [];
  }

  /// Compare two values for deep equality
  bool _deepEquals(dynamic a, dynamic b) {
    if (a == b) return true;
    if (a == null || b == null) return false;
    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!b.containsKey(key) || !_deepEquals(a[key], b[key])) {
          return false;
        }
      }
      return true;
    }
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (!_deepEquals(a[i], b[i])) return false;
      }
      return true;
    }
    return false;
  }

  /// Create a deep copy of a value
  dynamic _deepCopy(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return Map.fromEntries(
        value.entries.map((e) => MapEntry(e.key, _deepCopy(e.value))),
      );
    }
    if (value is List) {
      return value.map((e) => _deepCopy(e)).toList();
    }
    if (value is String || value is num || value is bool) {
      return value;
    }
    // For other types, try to convert to JSON and back
    try {
      final jsonString = jsonEncode(value);
      return jsonDecode(jsonString);
    } catch (e) {
      return value.toString();
    }
  }

  /// Dispose the inspector
  void dispose() {
    _changeController.close();
  }
}

/// Represents a state change
class StateChange {
  /// Creates a new StateChange instance
  const StateChange({
    required this.key,
    required this.previousState,
    required this.currentState,
    required this.timestamp,
  });

  /// Key identifying the state
  final String key;

  /// Previous state value
  final dynamic previousState;

  /// Current state value
  final dynamic currentState;

  /// Timestamp when the change occurred
  final DateTime timestamp;

  @override
  String toString() {
    return 'StateChange(key: $key, timestamp: $timestamp)';
  }
}
