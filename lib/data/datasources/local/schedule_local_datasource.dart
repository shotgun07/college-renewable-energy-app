import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class ScheduleLocalDatasource {
  static const _boxName = 'schedules_box';

  Future<void> cacheSchedules(String key, List<Map<String, dynamic>> schedules) async {
    final box = await Hive.openBox(_boxName);
    
    // Convert any Timestamp objects to Iso8601String for safe serialization
    final sanitizedList = schedules.map((schedule) {
       final newMap = Map<String, dynamic>.from(schedule);
       newMap.forEach((k, v) {
         if (v != null && v.runtimeType.toString() == 'Timestamp') {
           newMap[k] = v.toDate().toIso8601String();
         }
       });
       return newMap;
    }).toList();

    await box.put(key, jsonEncode(sanitizedList));
  }

  Future<List<Map<String, dynamic>>> getCachedSchedules(String key) async {
    final box = await Hive.openBox(_boxName);
    final String? cachedData = box.get(key);
    
    if (cachedData == null) return [];
    
    final List<dynamic> decodedList = jsonDecode(cachedData);
    
    return decodedList.map((data) => Map<String, dynamic>.from(data)).toList();
  }
}
