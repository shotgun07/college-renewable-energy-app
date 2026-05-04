import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/result_model.dart';

class ResultRemoteDatasource {
  final FirebaseFirestore _firestore;

  ResultRemoteDatasource(this._firestore);

  Stream<List<ResultModel>> getStudentResults(String studentID) {
    return _firestore
        .collection('results')
        .where('studentID', isEqualTo: studentID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ResultModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addResults(List<ResultModel> results) async {
    final batch = _firestore.batch();

    for (final result in results) {
      final docRef = _firestore.collection('results').doc();
      batch.set(docRef, result.toMap());
    }

    await batch.commit();
  }

  Stream<List<ResultModel>> getResultsByDepartmentAndSemester(
      String department, int semester) {
    return _firestore
        .collection('results')
        .where('department', isEqualTo: department)
        .where('semester', isEqualTo: semester)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ResultModel.fromFirestore(doc))
          .toList();
    });
  }
}
