import '../../domain/entities/stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/remote/stats_remote_datasource.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDatasource _remoteDatasource;

  StatsRepositoryImpl({required StatsRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Stats> getTeacherStats() async {
    return await _remoteDatasource.getTeacherStats();
  }
}
