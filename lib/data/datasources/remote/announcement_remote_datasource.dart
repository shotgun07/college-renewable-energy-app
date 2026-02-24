import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/announcement_model.dart';

class AnnouncementRemoteDatasource {
  final FirebaseFirestore _firestore;

  AnnouncementRemoteDatasource(this._firestore);

  Stream<List<AnnouncementModel>> getAnnouncements(
      String department, int semester, {int limit = 20, DateTime? startAfter}) {
    // Logic:
    // - Department matches user dept OR 'الكل'
    // - Semester matches user sem OR 0 (implied in client filtering usually, but can be done here if possible)
    // Firestore 'whereIn' supports up to 10 values.

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

          // Additional client-side filtering for semester if needed,
          // or we can just return all compatible department announcements
          // and let the repository/UI filter by semester if the query is complex.
          // But let's filter here for cleaner stream.

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
