import '../../domain/entities/user.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/remote/admin_remote_datasource.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource _remoteDatasource;

  AdminRepositoryImpl({required AdminRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Stream<List<User>> watchStudents() {
    return _remoteDatasource.watchStudents();
  }

  @override
  Future<void> updateStudentID(
      String uid, String name, String newId, String adminUid) {
    return _remoteDatasource.updateStudentID(uid, name, newId, adminUid);
  }

  @override
  Future<String> getUserName(String uid) {
    return _remoteDatasource.getUserName(uid);
  }

  @override
  Future<List<User>> getStudentsByDeptSemester(String dept, int semester) {
    return _remoteDatasource.getStudentsByDeptSemester(dept, semester);
  }

  @override
  Stream<List<User>> watchTeachersByKey(String key) {
    return _remoteDatasource.watchTeachersByKey(key);
  }
}
