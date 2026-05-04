import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/announcement_remote_datasource.dart';
import '../../data/datasources/local/announcement_local_datasource.dart';
import '../../data/datasources/local/offline_queue_datasource.dart';
import '../../data/repositories/announcement_repository_impl.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/usecases/announcement/add_announcement_usecase.dart';
import 'auth_provider.dart';

part 'announcement_provider.g.dart';

@riverpod
AnnouncementRemoteDatasource announcementRemoteDatasource(Ref ref) {
  return AnnouncementRemoteDatasource(ref.watch(firebaseFirestoreProvider));
}

@riverpod
AnnouncementLocalDatasource announcementLocalDatasource(Ref ref) {
  return AnnouncementLocalDatasource();
}

@riverpod
OfflineQueueDatasource offlineQueueDatasource(Ref ref) {
  return OfflineQueueDatasource();
}

@riverpod
AnnouncementRepository announcementRepository(Ref ref) {
  return AnnouncementRepositoryImpl(
      ref.watch(announcementRemoteDatasourceProvider),
      ref.watch(announcementLocalDatasourceProvider),
      ref.watch(offlineQueueDatasourceProvider),
  );
}

@riverpod
Stream<List<Announcement>> announcements(Ref ref, String department, int semester) {
  final repository = ref.watch(announcementRepositoryProvider);
  return repository.getAnnouncements(department, semester, limit: 20);
}

@riverpod
AddAnnouncementUseCase addAnnouncementUseCase(Ref ref) {
  return AddAnnouncementUseCase(ref.watch(announcementRepositoryProvider));
}
