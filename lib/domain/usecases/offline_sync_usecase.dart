import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/local/offline_queue_datasource.dart';

class OfflineSyncUseCase {
  final OfflineQueueDatasource _queue;
  final FirebaseFirestore _firestore;

  OfflineSyncUseCase(this._queue, this._firestore);

  Future<void> execute() async {
    final operations = await _queue.getQueue();

    for (final op in operations) {
      try {
        if (op.method == 'create') {
          await _firestore.collection(op.collection).doc(op.id).set(op.payload!);
        } else if (op.method == 'update') {
          await _firestore.collection(op.collection).doc(op.id).update(op.payload!);
        } else if (op.method == 'delete') {
          await _firestore.collection(op.collection).doc(op.id).delete();
        }
        await _queue.remove(op.id);
      } catch (e) {
        // Log error and retry later
        debugPrint('Offline sync failed for op ${op.id}: $e');
      }
    }
  }
}
