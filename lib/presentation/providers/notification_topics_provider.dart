import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/notification_service.dart';
import 'auth_provider.dart';

// This provider automatically listens to the current user and subscribes
// their device to the relevant Firebase Cloud Messaging (FCM) topics.
final notificationTopicsProvider = Provider<void>((ref) {
  final user = ref.watch(currentUserProvider);

  if (user == null) return;

  final ns = NotificationService();

  // General topics
  ns.subscribeToTopic('all');
  ns.subscribeToTopic('role_${user.role.name}');

  // Academic topics
  if (user.departmentName.isNotEmpty) {
    // Clean string format for FCM topic compatibility (no spaces)
    final safeDept = user.departmentName.replaceAll(' ', '_');
    ns.subscribeToTopic('dept_$safeDept');

    if (user.semester > 0) {
      ns.subscribeToTopic('dept_${safeDept}_sem_${user.semester}');
    }
  }
});
