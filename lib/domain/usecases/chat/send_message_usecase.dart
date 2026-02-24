import '../../repositories/chat_repository.dart';
import '../../entities/message.dart';

class SendMessageUseCase {
  final ChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<void> call(String threadId, Message message) async {
    return await _repository.sendMessage(threadId, message);
  }
}
