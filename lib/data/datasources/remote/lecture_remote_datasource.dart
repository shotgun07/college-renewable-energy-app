import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/lecture_model.dart';

class LectureRemoteDatasource {
  final FirebaseFirestore _firestore;

  LectureRemoteDatasource(this._firestore);


  Future<void> addLecture(LectureModel lecture) async {
    await _firestore.collection('lectures').add(lecture.toMap());
  }

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

  Future<void> deleteLecture(String lectureId) async {
    await _firestore.collection('lectures').doc(lectureId).delete();
  }
}
