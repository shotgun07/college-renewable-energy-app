import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineOperation {
  final String id;
  final String collection;
  final String method;
  final Map<String, dynamic>? payload;
  final int timestamp;

  OfflineOperation({
    required this.id,
    required this.collection,
    required this.method,
    this.payload,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'collection': collection,
        'method': method,
        'payload': payload,
        'timestamp': timestamp,
      };

  factory OfflineOperation.fromJson(Map<String, dynamic> json) {
    return OfflineOperation(
      id: json['id'],
      collection: json['collection'],
      method: json['method'],
      payload: json['payload'],
      timestamp: json['timestamp'],
    );
  }
}

class OfflineQueueDatasource {
  static const String _boxName = 'offline_queue';

  Future<Box<String>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  Future<void> enqueue(OfflineOperation operation) async {
    final box = await _openBox();
    await box.put(operation.id, jsonEncode(operation.toJson()));
  }

  Future<void> remove(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<List<OfflineOperation>> getQueue() async {
    final box = await _openBox();
    final List<OfflineOperation> operations = [];
    for (var value in box.values) {
      operations.add(OfflineOperation.fromJson(jsonDecode(value)));
    }
    operations.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return operations;
  }
}
