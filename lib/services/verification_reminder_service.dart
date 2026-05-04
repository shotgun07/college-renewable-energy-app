import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VerificationReminderService {
  static const String _lastReminderKey = 'last_verification_reminder_time';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks if the verification reminder should be shown.
  Future<bool> shouldShowReminder(String userID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? lastShown = prefs.getInt(_lastReminderKey);
      
      if (lastShown == null) return true;

      final DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(lastShown);
      final DateTime now = DateTime.now();
      
      // Remind every 24 hours
      return now.difference(lastDate).inHours >= 24;
    } catch (e) {
      debugPrint('Error checking reminder status: $e');
      return false;
    }
  }

  /// Marks the reminder as shown in local storage.
  Future<void> markReminderShown() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastReminderKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Updates Firestore to acknowledge the reminder dismissal.
  Future<void> dismissReminder(String userID) async {
    try {
      await _firestore.collection('users').doc(userID).update({
        'verificationReminderDismissed': true,
        'lastReminderDismissedAt': FieldValue.serverTimestamp(),
      });
      await markReminderShown();
    } catch (e) {
      debugPrint('Error dismissing reminder: $e');
    }
  }
}