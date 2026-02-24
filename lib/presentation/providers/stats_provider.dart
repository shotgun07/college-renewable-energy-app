import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/stats.dart';
import '../../data/datasources/remote/stats_remote_datasource.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/stats_repository.dart';
import '../../domain/usecases/stats/get_teacher_stats_usecase.dart';

part 'stats_provider.g.dart';

@riverpod
StatsRemoteDatasource statsRemoteDatasource(Ref ref) {
  return StatsRemoteDatasource();
}

@riverpod
StatsRepository statsRepository(Ref ref) {
  return StatsRepositoryImpl(
    remoteDatasource: ref.watch(statsRemoteDatasourceProvider),
  );
}

@riverpod
GetTeacherStatsUseCase getTeacherStatsUseCase(Ref ref) {
  return GetTeacherStatsUseCase(ref.watch(statsRepositoryProvider));
}

@riverpod
Future<Stats> teacherStats(Ref ref) async {
  final useCase = ref.watch(getTeacherStatsUseCaseProvider);
  return await useCase();
}
