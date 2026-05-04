import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../../../env/env.dart';

part 'ai_chat_provider.g.dart';

@riverpod
AiRepository aiRepository(Ref ref) {
  final apiKey = Env.geminiApiKey;
  return AiRepositoryImpl(apiKey: apiKey);
}

@riverpod
class AiChatNotifier extends _$AiChatNotifier {
  @override
  List<AiMessage> build() {
    return [];
  }

  Future<void> sendMessage(String text) async {
    final userMsg = AiMessage(content: text, role: AiRole.user, timestamp: DateTime.now());
    state = [...state, userMsg];

    final repo = ref.read(aiRepositoryProvider);
    final history = state.where((m) => m != userMsg).toList();

    final modelMsg = AiMessage(content: '', role: AiRole.model, timestamp: DateTime.now());
    state = [...state, modelMsg];

    String currentResponse = '';

    try {
      await for (final chunk in repo.sendMessageStream(history, text)) {
        currentResponse += chunk;
        
        state = [
          ...state.sublist(0, state.length - 1),
          AiMessage(content: currentResponse, role: AiRole.model, timestamp: modelMsg.timestamp),
        ];
      }
    } catch (e) {
       state = [
          ...state.sublist(0, state.length - 1),
          AiMessage(content: 'عذراً، حدث خطأ أثناء الاتصال بالخادم. يرجى تزويد مفتاح Google Gemini API.', role: AiRole.model, timestamp: modelMsg.timestamp),
        ];
    }
  }
}
