import '../entities/ai_message.dart';

abstract class AiRepository {
  Stream<String> sendMessageStream(List<AiMessage> history, String message);
}
