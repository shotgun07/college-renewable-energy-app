import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_enums.dart';

class Lecture {
  final String id;
  final String title;
  final String subject;
  final Department department;
  final int semester;
  final String teacherId;
  final String teacherName;
  final String downloadUrl;
  final DateTime createdAt;

  Lecture({
    required this.id,
    required this.title,
    required this.subject,
    required this.department,
    required this.semester,
    required this.teacherId,
    required this.teacherName,
    required this.downloadUrl,
    required this.createdAt,
  });

  factory Lecture.fromMap(String id, Map<String, dynamic> map) {
    return Lecture(
      id: id,
      title: (map['title'] ?? 'بدون عنوان').toString(),
      subject: (map['subject'] ?? '').toString(),
      department: Department.fromString(map['department']?.toString()),
      semester: int.tryParse((map['semester'] ?? '1').toString()) ?? 1,
      teacherId: (map['teacherId'] ?? '').toString(),
      teacherName: (map['teacherName'] ?? '').toString(),
      downloadUrl: (map['downloadUrl'] ?? '').toString(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'department': department.displayName,
      'semester': semester,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'downloadUrl': downloadUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
