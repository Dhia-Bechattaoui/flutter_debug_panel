import 'package:flutter/material.dart';
import 'models/debug_config.dart';
import 'models/network_log.dart';
import 'models/performance_metric.dart';
import 'network_logger.dart';
import 'performance_monitor.dart';
import 'state_inspector.dart';

/// Main debug panel widget that provides debugging tools
class DebugPanel extends StatefulWidget {
  /// Creates a new DebugPanel instance
  const DebugPanel({super.key, this.config = const DebugConfig(), this.child});

  /// Configuration for the debug panel
  final DebugConfig config;

  /// Child widget to wrap with the debug panel
  final Widget? child;

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleVisibility() => setState(() => _isVisible = !_isVisible);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Positioned(
          top: 50,
          right: 20,
          child: FloatingActionButton(
            onPressed: _toggleVisibility,
            backgroundColor: Colors.blue,
            child: Icon(
              _isVisible ? Icons.close : Icons.bug_report,
              color: Colors.white,
            ),
          ),
        ),
        if (_isVisible)
          Positioned(
            top: 120,
            right: 20,
            child: Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bug_report, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Debug Panel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _NetworkLogsTab(config: widget.config),
                        _StateInspectionTab(config: widget.config),
                        _PerformanceTab(config: widget.config),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(icon: Icon(Icons.network_check), text: 'Network'),
                      Tab(icon: Icon(Icons.analytics), text: 'State'),
                      Tab(icon: Icon(Icons.speed), text: 'Performance'),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _NetworkLogsTab extends StatelessWidget {
  const _NetworkLogsTab({required this.config});

  final DebugConfig config;

  @override
  Widget build(BuildContext context) {
    if (!config.enableNetworkLogging) {
      return const Center(child: Text('Network logging is disabled'));
    }

    return StreamBuilder(
      stream: NetworkLogger.instance.logs,
      builder: (context, snapshot) {
        final logs = NetworkLogger.instance.allLogs;

        if (logs.isEmpty) {
          return const Center(child: Text('No network logs yet'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text('${logs.length} requests'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => NetworkLogger.instance.clearLogs(),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log =
                      logs[logs.length - 1 - index]; // Show newest first
                  return _NetworkLogTile(log: log);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NetworkLogTile extends StatelessWidget {
  const _NetworkLogTile({required this.log});

  final NetworkLog log;

  @override
  Widget build(BuildContext context) {
    final isSuccess = log.statusCode != null && log.statusCode! < 400;
    final color = isSuccess ? Colors.green : Colors.red;

    return ExpansionTile(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              log.method,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              log.url,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (log.statusCode != null)
            Text(
              '${log.statusCode}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
        ],
      ),
      subtitle: Text(
        '${log.duration}ms • ${log.timestamp.toString().substring(11, 19)}',
        style: const TextStyle(fontSize: 12),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (log.requestBody != null) ...[
                const Text(
                  'Request Body:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(log.requestBody!),
                ),
                const SizedBox(height: 8),
              ],
              if (log.responseBody != null) ...[
                const Text(
                  'Response Body:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(log.responseBody!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StateInspectionTab extends StatelessWidget {
  const _StateInspectionTab({required this.config});

  final DebugConfig config;

  @override
  Widget build(BuildContext context) {
    if (!config.enableStateInspection) {
      return const Center(child: Text('State inspection is disabled'));
    }

    final states = StateInspector.instance.stateSnapshots;

    if (states.isEmpty) {
      return const Center(child: Text('No state snapshots yet'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Text('${states.length} state keys'),
              const Spacer(),
              TextButton(
                onPressed: () => StateInspector.instance.clearStates(),
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: states.length,
            itemBuilder: (context, index) {
              final key = states.keys.elementAt(index);
              final value = states[key];
              return _StateTile(stateKey: key, value: value);
            },
          ),
        ),
      ],
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({required this.stateKey, required this.value});

  final String stateKey;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(stateKey),
      subtitle: Text(value.runtimeType.toString()),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value.toString(),
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PerformanceTab extends StatelessWidget {
  const _PerformanceTab({required this.config});

  final DebugConfig config;

  @override
  Widget build(BuildContext context) => !config.enablePerformanceMonitoring
      ? const Center(child: Text('Performance monitoring is disabled'))
      : PerformanceMonitor.instance.allMetrics.isEmpty
          ? const Center(child: Text('No performance metrics yet'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        '${PerformanceMonitor.instance.allMetrics.length} metrics',
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            PerformanceMonitor.instance.clearMetrics(),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: PerformanceMonitor.instance.allMetrics.length,
                    itemBuilder: (context, index) {
                      final metric = PerformanceMonitor.instance.allMetrics[
                          PerformanceMonitor.instance.allMetrics.length -
                              1 -
                              index];
                      return _PerformanceMetricTile(metric: metric);
                    },
                  ),
                ),
              ],
            );
}

class _PerformanceMetricTile extends StatelessWidget {
  const _PerformanceMetricTile({required this.metric});

  final PerformanceMetric metric;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(metric.name),
      subtitle: Text(
        '${metric.timestamp.toString().substring(11, 19)} • ${metric.description ?? ''}',
      ),
      trailing: Text(
        '${metric.value.toStringAsFixed(2)} ${metric.unit}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
