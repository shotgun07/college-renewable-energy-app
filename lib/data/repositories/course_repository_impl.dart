import '../../domain/repositories/course_repository.dart';
import '../datasources/remote/course_remote_datasource.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_resource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDatasource _remoteDatasource;

  CourseRepositoryImpl({required CourseRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Stream<List<Course>> watchCourses() {
    return _remoteDatasource.watchCourses().map((list) => list.map((m) => m).toList());
  }

  @override
  Stream<List<Course>> coursesByDeptSemester(String department, int semester) {
    return _remoteDatasource.coursesByDeptSemester(department, semester).map((list) => list.map((m) => m).toList());
  }

  @override
  Stream<List<CourseResource>> courseResources(String courseId) {
    return _remoteDatasource.courseResources(courseId).map((list) => list.map((m) => m).toList());
  }

  @override
  Future<void> addCourse(Map<String, dynamic> data) {
    return _remoteDatasource.addCourse(data);
  }

  @override
  Future<void> updateCourse(String courseId, Map<String, dynamic> data) {
    return _remoteDatasource.updateCourse(courseId, data);
  }

  @override
  Future<void> deleteCourse(String courseId) {
    return _remoteDatasource.deleteCourse(courseId);
  }

  @override
  Future<void> addCourseResource(String courseId, Map<String, dynamic> data) {
    return _remoteDatasource.addCourseResource(courseId, data);
  }
}
