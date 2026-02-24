import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/stats.dart';

class StatsRemoteDatasource {
  final FirebaseFirestore _firestore;

  StatsRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Stats> getTeacherStats() async {
    final studentsQuery = _firestore.collection('users').where('role', isEqualTo: 'student');
    final lecturesQuery = _firestore.collection('lectures');
    final chatsQuery = _firestore.collection('threads');
    final schedulesQuery = _firestore.collection('schedules');

    final results = await Future.wait([
      studentsQuery.count().get(),
      lecturesQuery.count().get(),
      chatsQuery.count().get(),
      schedulesQuery.count().get(),
    ]);

    return Stats(
      totalStudents: results[0].count ?? 0,
      totalLectures: results[1].count ?? 0,
      totalChats: results[2].count ?? 0,
      totalSchedules: results[3].count ?? 0,
    );
  }
}
