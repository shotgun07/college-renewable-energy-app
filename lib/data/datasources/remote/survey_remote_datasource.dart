import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/survey.dart';

class SurveyRemoteDatasource {
  final FirebaseFirestore _firestore;

  SurveyRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> submitSurvey(Survey survey) async {
    await _firestore
        .collection('surveys')
        .doc(survey.id)
        .set(survey.toMap());
  }

  Stream<List<Survey>> getSurveysByCourse(String courseId) {
    return _firestore
        .collection('surveys')
        .where('courseId', isEqualTo: courseId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Survey.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<List<Survey>> getSurveysByStudent(String studentId) {
    return _firestore
        .collection('surveys')
        .where('studentId', isEqualTo: studentId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Survey.fromMap(d.id, d.data()))
            .toList());
  }
}
