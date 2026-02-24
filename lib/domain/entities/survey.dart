class Survey {
  final String id;
  final String studentId;
  final String courseId;
  final String courseName;
  final int rating;
  final String comments;
  final DateTime submittedAt;

  Survey({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.courseName,
    required this.rating,
    required this.comments,
    required this.submittedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'courseName': courseName,
      'rating': rating,
      'comments': comments,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory Survey.fromMap(String id, Map<String, dynamic> data) {
    return Survey(
      id: id,
      studentId: data['studentId'] ?? '',
      courseId: data['courseId'] ?? '',
      courseName: data['courseName'] ?? '',
      rating: data['rating'] ?? 0,
      comments: data['comments'] ?? '',
      submittedAt: data['submittedAt'] != null 
          ? DateTime.parse(data['submittedAt'])
          : DateTime.now(),
    );
  }
}
