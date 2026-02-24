import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/utils/firestore_keys.dart';

class ResultsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamStudentResults(String studentID) {
    return _db
        .collection(FirestoreCollections.results)
        .where(ResultFields.studentID, isEqualTo: studentID)
        .snapshots();
  }

  Future<void> addResult({
    required String studentID,
    required String studentName,
    required String subject,
    required num grade,
  }) async {
    await _db.collection(FirestoreCollections.results).add({
      ResultFields.studentID: studentID,
      ResultFields.studentName: studentName,
      ResultFields.subject: subject,
      ResultFields.grade: grade,
      ResultFields.uploadedAt: FieldValue.serverTimestamp(),
    });
  }

  WriteBatch batch() => _db.batch();
}
