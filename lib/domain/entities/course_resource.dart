enum ResourceType { pdf, video, link }

class CourseResource {
  final String id;
  final String courseId;
  final String title;
  final String url;
  final ResourceType type;

  CourseResource({
    required this.id,
    required this.courseId,
    required this.title,
    required this.url,
    required this.type,
  });
}
