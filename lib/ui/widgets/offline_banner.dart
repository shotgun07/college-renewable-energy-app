import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_info.dart';

/// A global widget that drops down when the device goes offline.
/// Wrap your main Scaffold body with this or place it at the top of your layout.
class OfflineBanner extends ConsumerWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);

    return Column(
      children: [
        connectivityState.when(
          data: (isOnline) {
            if (isOnline) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              color: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Text(
                'أنت غير متصل بالإنترنت. وضع عدم الاتصال مفعل.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        Expanded(child: child),
      ],
    );
  }
}
