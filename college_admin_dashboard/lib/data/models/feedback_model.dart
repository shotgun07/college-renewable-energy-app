import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String studentId;
  final String studentName;
  final String departmentName;
  final int rating;
  final String comment;
  final DateTime submittedAt;

  FeedbackModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.departmentName,
    required this.rating,
    required this.comment,
    required this.submittedAt,
  });

  factory FeedbackModel.fromMap(String id, Map<String, dynamic> data) {
    return FeedbackModel(
      id: id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? 'Unknown',
      departmentName: data['departmentName'] ?? '',
      rating: data['rating']?.toInt() ?? 5,
      comment: data['comment'] ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
