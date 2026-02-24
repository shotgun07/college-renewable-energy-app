import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AdminRemoteDatasource {
  final FirebaseFirestore _firestore;

  AdminRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<UserModel>> watchStudents() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  Future<void> updateStudentID(
      String uid, String name, String newId, String adminUid) async {
    final batch = _firestore.batch();

    final userRef = _firestore.collection('users').doc(uid);
    batch.update(userRef, {'studentID': newId});

    final auditRef = _firestore.collection('audit_logs').doc();
    batch.set(auditRef, {
      'action': 'UPDATE_STUDENT_ID',
      'targetUid': uid,
      'targetName': name,
      'newValue': newId,
      'timestamp': FieldValue.serverTimestamp(),
      'adminUid': adminUid,
    });

    await batch.commit();
  }

  Future<String> getUserName(String uid) async {
    if (uid.isEmpty) return 'مستخدم';
    final doc = await _firestore.collection('users').doc(uid).get();
    return (doc.data()?['fullName'] ?? 'مستخدم').toString();
  }

  Future<List<UserModel>> getStudentsByDeptSemester(
      String dept, int semester) async {
    final snap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .where('departmentName', isEqualTo: dept)
        .where('semester', isEqualTo: semester)
        .get();
    return snap.docs.map((d) => UserModel.fromFirestore(d)).toList();
  }

  Stream<List<UserModel>> watchTeachersByKey(String key) {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .where('teachingKeys', arrayContains: key)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => UserModel.fromFirestore(d)).toList());
  }
}
