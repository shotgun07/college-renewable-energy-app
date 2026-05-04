import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_enums.dart';

enum ResourceType { pdf, video, link }

class CourseResource {
  final String id;
  final String title;
  final ResourceType type;
  final String url;
  final DateTime date;

  CourseResource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type.toString().split('.').last,
      'url': url,
      'date': Timestamp.fromDate(date),
    };
  }

  factory CourseResource.fromMap(String id, Map<String, dynamic> data) {
    return CourseResource(
      id: id,
      title: data['title'] ?? 'بدون عنوان',
      type: _parseType(data['type']),
      url: data['url'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static ResourceType _parseType(String? type) {
    switch (type) {
      case 'video':
        return ResourceType.video;
      case 'link':
        return ResourceType.link;
      default:
        return ResourceType.pdf;
    }
  }
}

class Course {
  final String id;
  final String name;
  final Department department;
  final int semester;
  final String? teacherId;

  Course({
    required this.id,
    required this.name,
    required this.department,
    required this.semester,
    this.teacherId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department.displayName,
      'semester': semester,
      'teacherId': teacherId,
    };
  }

  factory Course.fromMap(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      name: data['name'] ?? 'مادة غير معروفة',
      department: Department.fromString(data['department']),
      semester: data['semester'] ?? 1,
      teacherId: data['teacherId'],
    );
  }
}
