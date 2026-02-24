class Result {
  final String id;
  final String studentID;
  final String studentName;
  final String department;
  final int semester;
  final String subject;
  final double midterm;
  final double final_;
  final double practical;
  final double total;
  final DateTime createdAt;

  const Result({
    required this.id,
    required this.studentID,
    required this.studentName,
    required this.department,
    required this.semester,
    required this.subject,
    required this.midterm,
    required this.final_,
    required this.practical,
    required this.total,
    required this.createdAt,
  });

  Result copyWith({
    String? id,
    String? studentID,
    String? studentName,
    String? department,
    int? semester,
    String? subject,
    double? midterm,
    double? final_,
    double? practical,
    double? total,
    DateTime? createdAt,
  }) {
    return Result(
      id: id ?? this.id,
      studentID: studentID ?? this.studentID,
      studentName: studentName ?? this.studentName,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      subject: subject ?? this.subject,
      midterm: midterm ?? this.midterm,
      final_: final_ ?? this.final_,
      practical: practical ?? this.practical,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
