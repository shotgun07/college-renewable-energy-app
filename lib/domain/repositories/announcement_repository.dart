import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  /// Get announcements for a specific department and semester
  /// If semester is 0, it should return announcements for all semesters (?) or just department wide?
  /// Usually backend filters by (dept == targetDept OR dept == 'All') AND (sem == targetSem OR sem == 0)
  Stream<List<Announcement>> getAnnouncements(String department, int semester, {int limit = 20, DateTime? startAfter});

  /// Create a new announcement (Admin)
  Future<void> createAnnouncement(Announcement announcement);

  /// Delete an announcement (Admin)
  Future<void> deleteAnnouncement(String id);
}
