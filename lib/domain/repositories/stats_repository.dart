import '../entities/stats.dart';

abstract class StatsRepository {
  Future<Stats> getTeacherStats();
}
