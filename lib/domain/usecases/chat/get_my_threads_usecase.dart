import '../../repositories/chat_repository.dart';
import '../../entities/chat_thread.dart';

class GetMyThreadsUseCase {
  final ChatRepository _repository;

  GetMyThreadsUseCase(this._repository);

  Stream<List<ChatThread>> call(String uid) {
    return _repository.getMyThreads(uid);
  }
}
