import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addAnnouncement({
    required String title,
    required String body,
    required String targetDept,
    required int targetSemester,
  }) async {
    await _db.collection('announcements').add({
      'title': title,
      'body': body,
      'department': targetDept,
      'semester': targetSemester,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}