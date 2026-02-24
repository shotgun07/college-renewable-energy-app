import '../../entities/stats.dart';
import '../../repositories/stats_repository.dart';

class GetTeacherStatsUseCase {
  final StatsRepository _repository;

  GetTeacherStatsUseCase(this._repository);

  Future<Stats> call() async {
    return await _repository.getTeacherStats();
  }
}
