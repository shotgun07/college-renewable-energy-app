import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feedback_model.dart';

final feedbackProvider = StreamProvider<List<FeedbackModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('feedbacks')
      .orderBy('submittedAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => FeedbackModel.fromMap(doc.id, doc.data())).toList();
  });
});
