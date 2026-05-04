import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/course_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_resource.dart';

// Explicit Riverpod providers (avoids depending on generated *.g.dart files)

final courseRemoteDatasourceProvider = Provider<CourseRemoteDatasource>((ref) {
  return CourseRemoteDatasource();
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(
    remoteDatasource: ref.watch(courseRemoteDatasourceProvider),
  );
});

final coursesStreamProvider = StreamProvider<List<Course>>((ref) {
  return ref.watch(courseRepositoryProvider).watchCourses();
});

class DeptSemesterParams {
  final String department;
  final int semester;
  DeptSemesterParams(this.department, this.semester);
}

final coursesByDeptSemesterProvider =
    StreamProvider.family<List<Course>, DeptSemesterParams>((ref, params) {
  return ref
      .watch(courseRepositoryProvider)
      .coursesByDeptSemester(params.department, params.semester);
});

final courseResourcesProvider =
    StreamProvider.family<List<CourseResource>, String>((ref, courseId) {
  return ref.watch(courseRepositoryProvider).courseResources(courseId);
});

