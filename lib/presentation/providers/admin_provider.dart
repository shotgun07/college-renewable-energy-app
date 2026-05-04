import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/admin_remote_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/entities/user.dart';

part 'admin_provider.g.dart';

@riverpod
AdminRemoteDatasource adminRemoteDatasource(Ref ref) {
  return AdminRemoteDatasource();
}

@riverpod
AdminRepository adminRepository(Ref ref) {
  return AdminRepositoryImpl(
    remoteDatasource: ref.watch(adminRemoteDatasourceProvider),
  );
}

@riverpod
Stream<List<User>> studentsStream(Ref ref) {
  return ref.watch(adminRepositoryProvider).watchStudents();
}

@riverpod
Stream<List<User>> teachersByKey(Ref ref, String key) {
  return ref.watch(adminRepositoryProvider).watchTeachersByKey(key);
}
