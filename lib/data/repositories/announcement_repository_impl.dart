import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/remote/announcement_remote_datasource.dart';
import '../datasources/local/announcement_local_datasource.dart';
import '../datasources/local/offline_queue_datasource.dart';
import '../models/announcement_model.dart';
import 'dart:async';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDatasource _remoteDatasource;
  final AnnouncementLocalDatasource _localDatasource;
  final OfflineQueueDatasource _offlineQueue;

  AnnouncementRepositoryImpl(this._remoteDatasource, this._localDatasource, this._offlineQueue);

  @override
  Stream<List<Announcement>> getAnnouncements(String department, int semester, {int limit = 20, DateTime? startAfter}) async* {
    final cacheKey = 'announcements_${department}_$semester';
    
    final cachedData = await _localDatasource.getCachedAnnouncements(cacheKey);
    if (cachedData.isNotEmpty) {
      yield cachedData;
    }
    
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

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

  Future<void> _enqueueOperation(String method, AnnouncementModel model) async {
    final op = OfflineOperation(
      id: model.id,
      collection: 'announcements',
      method: method,
      payload: model.toMap(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _offlineQueue.enqueue(op);
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

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (hasConnection) {
      try {
        await _remoteDatasource.createAnnouncement(model);
      } catch (e) {
        await _enqueueOperation('create', model);
      }
    } else {
      await _enqueueOperation('create', model);
    }
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (hasConnection) {
      try {
        await _remoteDatasource.deleteAnnouncement(id);
      } catch (e) {
        final op = OfflineOperation(
          id: id,
          collection: 'announcements',
          method: 'delete',
          payload: null,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        await _offlineQueue.enqueue(op);
      }
    } else {
      final op = OfflineOperation(
        id: id,
        collection: 'announcements',
        method: 'delete',
        payload: null,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      await _offlineQueue.enqueue(op);
    }
  }
}
