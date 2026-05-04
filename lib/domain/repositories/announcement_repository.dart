import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Stream<List<Announcement>> getAnnouncements(String department, int semester, {int limit = 20, DateTime? startAfter});

  Future<void> createAnnouncement(Announcement announcement);

  Future<void> deleteAnnouncement(String id);
}
