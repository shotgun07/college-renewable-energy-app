import '../models/lecture.dart';

class LectureService {
  Stream<List<Lecture>> getLecturesForStudent(String department, int semester) => Stream.value([]);
  Future<void> uploadLecture({
    required String title,
    required String subject,
    required String department,
    required int semester,
    required String teacherName,
    required String downloadUrl,
  }) async {}
}