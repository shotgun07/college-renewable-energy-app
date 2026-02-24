import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lecture.dart';

class LectureModel extends Lecture {
  const LectureModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.department,
    required super.semester,
    required super.teacherId,
    required super.teacherName,
    required super.downloadUrl,
    required super.createdAt,
  });

  factory LectureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return LectureModel(
      id: doc.id,
      title: (data['title'] ?? 'بدون عنوان').toString(),
      subject: (data['subject'] ?? '').toString(),
      department: (data['department'] ?? '').toString(),
      semester: int.tryParse((data['semester'] ?? '1').toString()) ?? 1,
      teacherId: (data['teacherId'] ?? '').toString(),
      teacherName: (data['teacherName'] ?? '').toString(),
      downloadUrl: (data['downloadUrl'] ?? '').toString(),
      createdAt: _toDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'department': department,
      'semester': semester,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'downloadUrl': downloadUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    return DateTime.now();
  }
}
