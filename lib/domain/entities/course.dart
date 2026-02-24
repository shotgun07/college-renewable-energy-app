class Course {
  final String id;
  final String name;
  final String department;
  final int semester;
  final String? description;

  Course({
    required this.id,
    required this.name,
    required this.department,
    required this.semester,
    this.description,
  });
}
