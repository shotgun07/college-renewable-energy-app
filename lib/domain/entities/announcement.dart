class Announcement {
  final String id;
  final String title;
  final String body;
  final String department;
  final int semester; // 0 means all semesters
  final DateTime createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.department,
    required this.semester,
    required this.createdAt,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? body,
    String? department,
    int? semester,
    DateTime? createdAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
