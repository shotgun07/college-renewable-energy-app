import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/announcement_model.dart';

class AnnouncementRemoteDatasource {
  final FirebaseFirestore _firestore;

  AnnouncementRemoteDatasource(this._firestore);

  Stream<List<AnnouncementModel>> getAnnouncements(
      String department, int semester, {int limit = 20, DateTime? startAfter}) {

    var query = _firestore
        .collection('announcements')
        .where('department', whereIn: [department, 'الكل'])
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfter([Timestamp.fromDate(startAfter)]);
    }

    return query.snapshots().map((snapshot) {
          final allDocs =
              snapshot.docs.map((doc) => AnnouncementModel.fromFirestore(doc));

          return allDocs
              .where((a) => a.semester == 0 || a.semester == semester)
              .toList();
        });
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    await _firestore.collection('announcements').add(announcement.toMap());
  }

  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection('announcements').doc(id).delete();
  }
}
