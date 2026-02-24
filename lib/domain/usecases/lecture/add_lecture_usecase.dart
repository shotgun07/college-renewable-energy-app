import '../../repositories/lecture_repository.dart';
import '../../entities/lecture.dart';

class AddLectureUseCase {
  final LectureRepository _repository;

  AddLectureUseCase(this._repository);

  Future<void> call(Lecture lecture) async {
    return await _repository.addLecture(lecture);
  }
}
