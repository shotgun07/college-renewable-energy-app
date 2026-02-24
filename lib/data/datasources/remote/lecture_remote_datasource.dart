import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/lecture_model.dart';

class LectureRemoteDatasource {
  final FirebaseFirestore _firestore;

  LectureRemoteDatasource(this._firestore);

  /// Add a new lecture
  Future<void> addLecture(LectureModel lecture) async {
    await _firestore.collection('lectures').add(lecture.toMap());
  }

  /// Get lectures for student (by department and semester)
  Stream<List<LectureModel>> getLecturesForStudent(
      String department, int semester) {
    return _firestore
        .collection('lectures')
        .where('department', isEqualTo: department)
        .where('semester', isEqualTo: semester)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LectureModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get lectures by teacher
  Stream<List<LectureModel>> getLecturesByTeacher(String teacherId) {
    return _firestore
        .collection('lectures')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LectureModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Delete a lecture
  Future<void> deleteLecture(String lectureId) async {
    await _firestore.collection('lectures').doc(lectureId).delete();
  }
}
