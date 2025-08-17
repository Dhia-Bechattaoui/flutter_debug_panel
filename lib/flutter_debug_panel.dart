/// A comprehensive in-app debug panel for Flutter development.
///
/// This package provides a powerful debugging toolkit that includes:
///
/// * **Network Logging**: Intercept and log HTTP requests/responses with detailed information
/// * **State Inspection**: Monitor and inspect app state changes in real-time
/// * **Performance Monitoring**: Track performance metrics and execution times
/// * **In-App Debug Interface**: Beautiful, tabbed debug panel accessible during development
///
/// ## Getting Started
///
/// Wrap your app with the `DebugPanel` widget:
///
/// ```dart
/// import 'package:flutter_debug_panel/flutter_debug_panel.dart';
///
/// void main() {
///   runApp(
///     DebugPanel(
///       config: const DebugConfig(
///         enableNetworkLogging: true,
///         enableStateInspection: true,
///         enablePerformanceMonitoring: true,
///       ),
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// ## Features
///
/// - **Automatic HTTP interception** when using the `http` package
/// - **Real-time state monitoring** with change detection
/// - **Performance profiling** with custom metrics support
/// - **Configurable logging** with customizable limits and filters
/// - **Cross-platform support** for iOS, Android, Web, Windows, macOS, and Linux
///
/// ## Architecture
///
/// The package is built with a modular architecture:
/// - `DebugPanel`: Main widget that provides the debug interface
/// - `NetworkLogger`: Handles HTTP request/response logging
/// - `StateInspector`: Manages state capture and inspection
/// - `PerformanceMonitor`: Tracks performance metrics
/// - `DebugConfig`: Configuration options for all features
///
/// For more information, see the [README](https://github.com/Dhia-Bechattaoui/flutter_debug_panel#readme).
library flutter_debug_panel;

export 'src/debug_panel.dart';
export 'src/models/debug_config.dart';
export 'src/models/network_log.dart';
export 'src/models/performance_metric.dart';
export 'src/network_logger.dart';
export 'src/performance_monitor.dart';
export 'src/state_inspector.dart';
