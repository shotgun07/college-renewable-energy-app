import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/remote/announcement_remote_datasource.dart';
import '../datasources/local/announcement_local_datasource.dart';
import '../models/announcement_model.dart';
import 'dart:async';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDatasource _remoteDatasource;
  final AnnouncementLocalDatasource _localDatasource;

  AnnouncementRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Stream<List<Announcement>> getAnnouncements(String department, int semester, {int limit = 20, DateTime? startAfter}) async* {
    final cacheKey = 'announcements_${department}_$semester';
    
    // 1. Yield Local Cache first
    final cachedData = await _localDatasource.getCachedAnnouncements(cacheKey);
    if (cachedData.isNotEmpty) {
      yield cachedData;
    }
    
    // 2. Check Connection
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    // 3. Fetch Remote and Cache
    if (hasConnection) {
      await for (final remoteData in _remoteDatasource.getAnnouncements(department, semester, limit: limit, startAfter: startAfter)) {
        final modelsToCache = remoteData.map((a) => AnnouncementModel(
          id: a.id,
          title: a.title,
          body: a.body,
          department: a.department,
          semester: a.semester,
          createdAt: a.createdAt,
        )).toList();
        
        await _localDatasource.cacheAnnouncements(cacheKey, modelsToCache);
        yield remoteData;
      }
    }
  }

  @override
  Future<void> createAnnouncement(Announcement announcement) async {
    final model = AnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      department: announcement.department,
      semester: announcement.semester,
      createdAt: announcement.createdAt,
    );
    await _remoteDatasource.createAnnouncement(model);
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    await _remoteDatasource.deleteAnnouncement(id);
  }
}
