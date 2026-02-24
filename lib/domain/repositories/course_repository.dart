import '../entities/course.dart';
import '../entities/course_resource.dart';

abstract class CourseRepository {
  Stream<List<Course>> watchCourses();
  Stream<List<Course>> coursesByDeptSemester(String department, int semester);
  Stream<List<CourseResource>> courseResources(String courseId);
  Future<void> addCourse(Map<String, dynamic> data);
  Future<void> updateCourse(String courseId, Map<String, dynamic> data);
  Future<void> deleteCourse(String courseId);
  Future<void> addCourseResource(String courseId, Map<String, dynamic> data);
}
