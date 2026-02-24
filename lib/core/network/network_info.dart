import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider that listens to connectivity changes and emits a boolean
// indicating whether the device is currently online.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  // Yield initial state
  final initialResult = await connectivity.checkConnectivity();
  yield !initialResult.contains(ConnectivityResult.none);

  // Listen to changes
  await for (final results in connectivity.onConnectivityChanged) {
    yield !results.contains(ConnectivityResult.none);
  }
});
