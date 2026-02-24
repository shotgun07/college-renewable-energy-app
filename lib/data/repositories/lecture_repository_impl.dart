import '../../domain/entities/lecture.dart';
import '../../domain/repositories/lecture_repository.dart';
import '../datasources/remote/lecture_remote_datasource.dart';
import '../models/lecture_model.dart';

class LectureRepositoryImpl implements LectureRepository {
  final LectureRemoteDatasource _remoteDatasource;

  LectureRepositoryImpl(this._remoteDatasource);

  @override
  Future<void> addLecture(Lecture lecture) async {
    final model = LectureModel(
      id: lecture.id,
      title: lecture.title,
      subject: lecture.subject,
      department: lecture.department,
      semester: lecture.semester,
      teacherId: lecture.teacherId,
      teacherName: lecture.teacherName,
      downloadUrl: lecture.downloadUrl,
      createdAt: lecture.createdAt,
    );
    await _remoteDatasource.addLecture(model);
  }

  @override
  Stream<List<Lecture>> getLecturesForStudent(String department, int semester) {
    return _remoteDatasource.getLecturesForStudent(department, semester);
  }

  @override
  Stream<List<Lecture>> getLecturesByTeacher(String teacherId) {
    return _remoteDatasource.getLecturesByTeacher(teacherId);
  }

  @override
  Future<void> deleteLecture(String lectureId) async {
    await _remoteDatasource.deleteLecture(lectureId);
  }
}
