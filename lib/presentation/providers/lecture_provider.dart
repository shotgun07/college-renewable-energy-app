import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/lecture_remote_datasource.dart';
import '../../data/repositories/lecture_repository_impl.dart';
import '../../domain/repositories/lecture_repository.dart';
import '../../domain/entities/lecture.dart';
import '../../domain/usecases/lecture/add_lecture_usecase.dart';
import '../../domain/usecases/lecture/get_lectures_for_student_usecase.dart';
import 'auth_provider.dart';

part 'lecture_provider.g.dart';

// Datasource
@riverpod
LectureRemoteDatasource lectureRemoteDatasource(Ref ref) {
  return LectureRemoteDatasource(ref.watch(firebaseFirestoreProvider));
}

// Repository
@riverpod
LectureRepository lectureRepository(Ref ref) {
  return LectureRepositoryImpl(ref.watch(lectureRemoteDatasourceProvider));
}

// UseCases
@riverpod
AddLectureUseCase addLectureUseCase(Ref ref) {
  return AddLectureUseCase(ref.watch(lectureRepositoryProvider));
}

@riverpod
GetLecturesForStudentUseCase getLecturesForStudentUseCase(Ref ref) {
  return GetLecturesForStudentUseCase(ref.watch(lectureRepositoryProvider));
}

// Streams
@riverpod
Stream<List<Lecture>> lecturesForStudent(Ref ref, String department, int semester) {
  final repository = ref.watch(lectureRepositoryProvider);
  return repository.getLecturesForStudent(department, semester);
}

@riverpod
Stream<List<Lecture>> lecturesByTeacher(Ref ref, String teacherId) {
  final repository = ref.watch(lectureRepositoryProvider);
  return repository.getLecturesByTeacher(teacherId);
}
