import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleRemoteDatasource {
  final FirebaseFirestore _firestore;

  ScheduleRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getSchedule(String deptCode, int semester) {
    return _firestore
        .collection('schedules')
        .where('departmentCode', isEqualTo: deptCode)
        .where('semester', isEqualTo: semester)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getAllSchedules() {
    return _firestore
        .collection('schedules')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
