import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/course_model.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/course_resource.dart';

class CourseRemoteDatasource {
  final FirebaseFirestore _firestore;

  CourseRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Course>> watchCourses() {
    return _firestore
        .collection('courses')
        .orderBy('department')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Course>> coursesByDeptSemester(String department, int semester) {
    return _firestore
        .collection('courses')
        .where('department', isEqualTo: department)
        .where('semester', isEqualTo: semester)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => CourseModel.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<List<CourseResource>> courseResources(String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .collection('resources')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => CourseResourceModel.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> addCourse(Map<String, dynamic> data) async {
    await _firestore.collection('courses').add(data);
  }

  Future<void> updateCourse(String courseId, Map<String, dynamic> data) async {
    await _firestore.collection('courses').doc(courseId).update(data);
  }

  Future<void> deleteCourse(String courseId) async {
    await _firestore.collection('courses').doc(courseId).delete();
  }

  Future<void> addCourseResource(
      String courseId, Map<String, dynamic> data) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('resources')
        .add(data);
  }
}
