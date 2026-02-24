import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/schedule_remote_datasource.dart';
import '../../data/datasources/local/schedule_local_datasource.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../domain/repositories/schedule_repository.dart';

part 'schedule_provider.g.dart';

@riverpod
ScheduleRemoteDatasource scheduleRemoteDatasource(Ref ref) {
  return ScheduleRemoteDatasource();
}

@riverpod
ScheduleLocalDatasource scheduleLocalDatasource(Ref ref) {
  return ScheduleLocalDatasource();
}

@riverpod
ScheduleRepository scheduleRepository(Ref ref) {
  return ScheduleRepositoryImpl(
    remoteDatasource: ref.watch(scheduleRemoteDatasourceProvider),
    localDatasource: ref.watch(scheduleLocalDatasourceProvider),
  );
}

@riverpod
Stream<List<Map<String, dynamic>>> scheduleStream(
    Ref ref, String deptCode, int semester) {
  return ref.watch(scheduleRepositoryProvider).getSchedule(deptCode, semester);
}

@riverpod
Stream<List<Map<String, dynamic>>> allSchedules(Ref ref) {
  return ref.watch(scheduleRepositoryProvider).getAllSchedules();
}
