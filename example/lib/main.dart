import 'package:flutter/material.dart';
import 'package:flutter_debug_panel/flutter_debug_panel.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    DebugPanel(
      config: const DebugConfig(
        enableNetworkLogging: true,
        enableStateInspection: true,
        enablePerformanceMonitoring: true,
        maxNetworkLogs: 50,
        maxPerformanceMetrics: 25,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Debug Panel Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Debug Panel Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _userData = 'No data loaded';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Capture initial state
    StateInspector.instance.captureState('counter', _counter);
    StateInspector.instance.captureState('user_data', _userData);
    StateInspector.instance.captureState('is_loading', _isLoading);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // Capture state change
    StateInspector.instance.captureState('counter', _counter);
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    StateInspector.instance.captureState('is_loading', _isLoading);

    try {
      // Measure execution time
      final result = await PerformanceMonitor.instance.measureExecutionTime(
        () => _fetchData(),
        name: 'data_fetch',
        tags: {'source': 'api'},
      );

      setState(() {
        _userData = result;
        _isLoading = false;
      });

      StateInspector.instance.captureState('user_data', _userData);
      StateInspector.instance.captureState('is_loading', _isLoading);

      // Record success metric
      PerformanceMonitor.instance.recordMetric(
        name: 'data_load_success',
        value: 1.0,
        unit: 'count',
        description: 'Successful data loads',
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      StateInspector.instance.captureState('is_loading', _isLoading);

      // Record error metric
      PerformanceMonitor.instance.recordMetric(
        name: 'data_load_error',
        value: 1.0,
        unit: 'count',
        description: 'Failed data loads',
        tags: {'error': e.toString()},
      );
    }
  }

  Future<String> _fetchData() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    // Make actual HTTP request to demonstrate network logging
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );

      if (response.statusCode == 200) {
        return 'Data loaded successfully: ${response.body.substring(0, 100)}...';
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadData,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Load Data'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _userData,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap the debug button (top right) to open the debug panel!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
