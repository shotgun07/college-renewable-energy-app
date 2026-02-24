class Lecture {
  final String id;
  final String title;
  final String subject;
  final String department;
  final int semester;
  final String teacherId;
  final String teacherName;
  final String downloadUrl;
  final DateTime createdAt;

  const Lecture({
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

  Lecture copyWith({
    String? id,
    String? title,
    String? subject,
    String? department,
    int? semester,
    String? teacherId,
    String? teacherName,
    String? downloadUrl,
    DateTime? createdAt,
  }) {
    return Lecture(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
