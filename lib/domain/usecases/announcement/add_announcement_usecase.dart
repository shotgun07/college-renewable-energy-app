import '../../repositories/announcement_repository.dart';
import '../../entities/announcement.dart';

class AddAnnouncementUseCase {
  final AnnouncementRepository _repository;

  AddAnnouncementUseCase(this._repository);

  Future<void> call(Announcement announcement) async {
    return await _repository.createAnnouncement(announcement);
  }
}
