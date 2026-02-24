import 'package:hive_flutter/hive_flutter.dart';
import '../../models/announcement_model.dart';
import 'dart:convert';

class AnnouncementLocalDatasource {
  static const _boxName = 'announcements_box';

  Future<void> cacheAnnouncements(String key, List<AnnouncementModel> announcements) async {
    final box = await Hive.openBox(_boxName);
    final List<Map<String, dynamic>> dataToStore = announcements.map((a) => {
      'id': a.id,
      'title': a.title,
      'body': a.body,
      'department': a.department,
      'semester': a.semester,
      'createdAt': a.createdAt.toIso8601String(),
    }).toList();
    
    await box.put(key, jsonEncode(dataToStore));
  }

  Future<List<AnnouncementModel>> getCachedAnnouncements(String key) async {
    final box = await Hive.openBox(_boxName);
    final String? cachedData = box.get(key);
    
    if (cachedData == null) return [];
    
    final List<dynamic> decodedList = jsonDecode(cachedData);
    
    return decodedList.map((data) => AnnouncementModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? 0,
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    )).toList();
  }
}
