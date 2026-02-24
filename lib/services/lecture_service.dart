import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lecture.dart';

class LectureService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addLecture({
    required String title,
    required String subject,
    required String department,
    required int semester,
    required String teacherId,
    required String teacherName,
    required String downloadUrl,
  }) async {
    await _db.collection('lectures').add({
      'title': title,
      'subject': subject,
      'department': department,
      'semester': semester,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'downloadUrl': downloadUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Lecture>> getLecturesForStudent(String dept, int semester) {
    return _db
        .collection('lectures')
        .where('department', isEqualTo: dept)
        .where('semester', isEqualTo: semester)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Lecture.fromMap(doc.id, doc.data()))
        .toList());
  }

  Stream<List<Lecture>> getLecturesByTeacher(String teacherId) {
    return _db
        .collection('lectures')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Lecture.fromMap(doc.id, doc.data()))
        .toList());
  }
}