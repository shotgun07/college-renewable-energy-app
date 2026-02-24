import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/remote/schedule_remote_datasource.dart';
import '../datasources/local/schedule_local_datasource.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDatasource _remoteDatasource;
  final ScheduleLocalDatasource _localDatasource;

  ScheduleRepositoryImpl({
    required ScheduleRemoteDatasource remoteDatasource,
    required ScheduleLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Stream<List<Map<String, dynamic>>> getSchedule(String deptCode, int semester) async* {
    final cacheKey = 'schedule_${deptCode}_$semester';
    
    final cachedData = await _localDatasource.getCachedSchedules(cacheKey);
    if (cachedData.isNotEmpty) {
      yield cachedData;
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (hasConnection) {
      await for (final remoteData in _remoteDatasource.getSchedule(deptCode, semester)) {
        await _localDatasource.cacheSchedules(cacheKey, remoteData);
        yield remoteData;
      }
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllSchedules() async* {
    final cacheKey = 'all_schedules';
    
    final cachedData = await _localDatasource.getCachedSchedules(cacheKey);
    if (cachedData.isNotEmpty) {
      yield cachedData;
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (hasConnection) {
      await for (final remoteData in _remoteDatasource.getAllSchedules()) {
        await _localDatasource.cacheSchedules(cacheKey, remoteData);
        yield remoteData;
      }
    }
  }
}
