import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage verification reminders for unverified users
class VerificationReminderService {
  static const String _lastDismissedKey =
      'verification_reminder_last_dismissed';
  static const String _dismissCountKey = 'verification_reminder_dismiss_count';

  /// Duration to wait before showing reminder again after dismissal
  /// Starts at 1 day, increases with each dismissal
  Duration _getReminderInterval(int dismissCount) {
    if (dismissCount == 0) {
      return const Duration(hours: 1); // Show after 1 hour initially
    } else if (dismissCount == 1) {
      return const Duration(days: 1); // Then daily
    } else if (dismissCount < 5) {
      return const Duration(days: 3); // Then every 3 days
    } else {
      return const Duration(days: 7); // Then weekly
    }
  }

  /// Check if reminder should be shown to the user
  Future<bool> shouldShowReminder(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    final lastDismissedStr = prefs.getString('${_lastDismissedKey}_$userId');
    if (lastDismissedStr == null) {
      // Never dismissed, show reminder
      return true;
    }

    final lastDismissed = DateTime.parse(lastDismissedStr);
    final dismissCount = prefs.getInt('${_dismissCountKey}_$userId') ?? 0;
    final interval = _getReminderInterval(dismissCount);

    final nextReminderTime = lastDismissed.add(interval);
    final now = DateTime.now();

    // Show if we've passed the next reminder time
    return now.isAfter(nextReminderTime);
  }

  /// Mark reminder as dismissed by user
  Future<void> dismissReminder(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    // Record dismissal time
    await prefs.setString(
        '${_lastDismissedKey}_$userId', DateTime.now().toIso8601String());

    // Increment dismiss count
    final currentCount = prefs.getInt('${_dismissCountKey}_$userId') ?? 0;
    await prefs.setInt('${_dismissCountKey}_$userId', currentCount + 1);
  }

  /// Clear reminder state (called when user verifies email)
  Future<void> clearReminderState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_lastDismissedKey}_$userId');
    await prefs.remove('${_dismissCountKey}_$userId');
  }

  /// Get the current dismiss count for analytics
  Future<int> getDismissCount(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_dismissCountKey}_$userId') ?? 0;
  }

  /// Force show reminder (called by admin or for important updates)
  Future<void> forceShowReminder(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_lastDismissedKey}_$userId');
    // Keep dismiss count to maintain interval logic
  }
}
