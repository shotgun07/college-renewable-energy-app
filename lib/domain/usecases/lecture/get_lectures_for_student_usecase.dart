import '../../repositories/lecture_repository.dart';
import '../../entities/lecture.dart';

class GetLecturesForStudentUseCase {
  final LectureRepository _repository;

  GetLecturesForStudentUseCase(this._repository);

  Stream<List<Lecture>> call(String department, int semester) {
    return _repository.getLecturesForStudent(department, semester);
  }
}
