import 'example/lib/simple_example.dart';

/// Simple script to run the Flutter Debug Panel example
void main() {
  print('Starting Flutter Debug Panel Example...\n');

  try {
    SimpleExample.run();
  } catch (e) {
    print('Error running example: $e');
  }

  print('\nExample completed successfully!');
}
