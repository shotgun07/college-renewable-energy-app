import '../entities/user.dart';

abstract class AdminRepository {
  Stream<List<User>> watchStudents();
  Future<void> updateStudentID(
      String uid, String name, String newId, String adminUid);
  Future<String> getUserName(String uid);
  Future<List<User>> getStudentsByDeptSemester(String dept, int semester);
  Stream<List<User>> watchTeachersByKey(String key);
}
