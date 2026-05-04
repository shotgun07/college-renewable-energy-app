import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/feedback_model.dart';


final feedbackRepositoryProvider = Provider((ref) => FeedbackRepository());

class FeedbackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitFeedback(FeedbackModel feedback) async {
    await _firestore.collection('feedbacks').add(feedback.toMap());
  }

  Stream<List<FeedbackModel>> getFeedbacks({String? departmentName}) {
    Query query = _firestore.collection('feedbacks').orderBy('submittedAt', descending: true);
    
    if (departmentName != null && departmentName.isNotEmpty) {
      query = query.where('departmentName', isEqualTo: departmentName);
    }

    return query.snapshots().map((snapshot) {

      return snapshot.docs.map((doc) => 
        FeedbackModel.fromMap(doc.id, doc.data() as Map<String, dynamic>)
      ).toList();
    });
  }
}
