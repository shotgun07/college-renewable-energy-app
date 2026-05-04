import '../entities/lecture.dart';

abstract class LectureRepository {
  Future<void> addLecture(Lecture lecture);

  Stream<List<Lecture>> getLecturesForStudent(String department, int semester);

  Stream<List<Lecture>> getLecturesByTeacher(String teacherId);

  Future<void> deleteLecture(String lectureId);
}
