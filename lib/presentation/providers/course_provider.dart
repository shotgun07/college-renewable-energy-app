import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/course_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_resource.dart';

part 'course_provider.g.dart';

@riverpod
CourseRemoteDatasource courseRemoteDatasource(Ref ref) {
  return CourseRemoteDatasource();
}

@riverpod
CourseRepository courseRepository(Ref ref) {
  return CourseRepositoryImpl(
    remoteDatasource: ref.watch(courseRemoteDatasourceProvider),
  );
}

@riverpod
Stream<List<Course>> coursesStream(Ref ref) {
  return ref.watch(courseRepositoryProvider).watchCourses();
}

@riverpod
Stream<List<Course>> coursesByDeptSemester(
    Ref ref, String department, int semester) {
  return ref.watch(courseRepositoryProvider).coursesByDeptSemester(department, semester);
}

@riverpod
Stream<List<CourseResource>> courseResources(
    Ref ref, String courseId) {
  return ref.watch(courseRepositoryProvider).courseResources(courseId);
}

