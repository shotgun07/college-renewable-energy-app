import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/result.dart';

class ResultModel extends Result {
  const ResultModel({
    required super.id,
    required super.studentID,
    required super.studentName,
    required super.department,
    required super.semester,
    required super.subject,
    required super.midterm,
    required super.final_,
    required super.practical,
    required super.total,
    required super.createdAt,
  });

  factory ResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ResultModel(
      id: doc.id,
      studentID: (data['studentID'] ?? '').toString(),
      studentName: (data['studentName'] ?? '').toString(),
      department: (data['department'] ?? '').toString(),
      semester: int.tryParse((data['semester'] ?? '1').toString()) ?? 1,
      subject: (data['subject'] ?? '').toString(),
      midterm: _toDouble(data['midterm']),
      final_: _toDouble(data['final']),
      practical: _toDouble(data['practical']),
      total: _toDouble(data['total']),
      createdAt: _toDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentID': studentID,
      'studentName': studentName,
      'department': department,
      'semester': semester,
      'subject': subject,
      'midterm': midterm,
      'final': final_,
      'practical': practical,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    return DateTime.now();
  }
}
