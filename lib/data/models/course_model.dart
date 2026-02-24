import '../../domain/entities/course.dart';
import '../../domain/entities/course_resource.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.name,
    required super.department,
    required super.semester,
    super.description,
  });

  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id: id,
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      semester: map['semester'] ?? 1,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'semester': semester,
      'description': description,
    };
  }
}

class CourseResourceModel extends CourseResource {
  CourseResourceModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.url,
    required super.type,
  });

  factory CourseResourceModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseResourceModel(
      id: id,
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: _parseType(map['type']),
    );
  }

  static ResourceType _parseType(String? type) {
    switch (type) {
      case 'pdf':
        return ResourceType.pdf;
      case 'video':
        return ResourceType.video;
      default:
        return ResourceType.link;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'url': url,
      'type': type.name,
    };
  }
}
