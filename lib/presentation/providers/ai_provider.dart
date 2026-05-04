import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/ai_service.dart';

part 'ai_provider.g.dart';

@riverpod
AiService aiService(Ref ref) {
  return AiService();
}

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AiMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class AiChatState {
  final List<AiMessage> messages;
  final bool isLoading;
  final String? error;

  AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@riverpod
class AiChat extends _$AiChat {
  @override
  AiChatState build() {
    return AiChatState();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = AiMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final aiService = ref.read(aiServiceProvider);
      final response = await aiService.sendMessage(text);
      final aiMessage = AiMessage(text: response, isUser: false);
      
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'ÙØ´Ù„ Ø¥Ø±Ø³Ø§Ù„ Ø§Ù„Ø±Ø³Ø§Ù„Ø©: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
  
  void resetChat() {
    state = AiChatState();
  }
}
