import '../entities/lecture.dart';

abstract class LectureRepository {
  /// Add a new lecture
  Future<void> addLecture(Lecture lecture);

  /// Get lectures for a student (by department and semester)
  Stream<List<Lecture>> getLecturesForStudent(String department, int semester);

  /// Get lectures by teacher
  Stream<List<Lecture>> getLecturesByTeacher(String teacherId);

  /// Delete a lecture
  Future<void> deleteLecture(String lectureId);
}
