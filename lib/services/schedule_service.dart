import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/utils/firestore_keys.dart';

class ScheduleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamSchedule({
    required String departmentCode,
    required int semester,
  }) {
    return _db
        .collection(FirestoreCollections.schedules)
        .where(ScheduleFields.departmentCode, isEqualTo: departmentCode)
        .where(ScheduleFields.semester, isEqualTo: semester)
        .orderBy(ScheduleFields.createdAt, descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> addSchedule({
    required String departmentCode,
    required int semester,
    required String title,
    required List<Map<String, dynamic>> items,
  }) async {
    await _db.collection(FirestoreCollections.schedules).add({
      ScheduleFields.departmentCode: departmentCode,
      ScheduleFields.semester: semester,
      ScheduleFields.title: title,
      ScheduleFields.items: items,
      ScheduleFields.createdAt: FieldValue.serverTimestamp(),
    });
  }
}
