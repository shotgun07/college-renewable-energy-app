import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!mounted) return;
      final isOffline = results.every((r) => r == ConnectivityResult.none);
      if (_isOffline != isOffline) {
        setState(() => _isOffline = isOffline);
      }
    });

    // Check initial status
    Connectivity().checkConnectivity().then((results) {
      if (!mounted) return;
      final isOffline = results.every((r) => r == ConnectivityResult.none);
      if (_isOffline != isOffline) {
        setState(() => _isOffline = isOffline);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        if (_isOffline)
          Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'أنت غير متصل بالإنترنت حالياً.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
