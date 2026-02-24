import 'package:google_generative_ai/google_generative_ai.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  final GenerativeModel _model;

  AiRepositoryImpl({required String apiKey}) 
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey,
          systemInstruction: Content.system(
              "أنت مساعد افتراضي ذكي لكلية الطاقة المتجددة. "
              "تم تصميمك للإجابة على أسئلة الطلاب حول الجداول، المحاضرات، المقررات وغيرها من الأمور الأكاديمية. "
              "إجاباتك يجب أن تكون دقيقة وواضحة وباللغة العربية."
          ),
        );

  @override
  Stream<String> sendMessageStream(List<AiMessage> history, String message) async* {
    final chat = _model.startChat(
      history: history.map((msg) => Content(
        msg.role == AiRole.user ? 'user' : 'model', 
        [TextPart(msg.content)]
      )).toList(),
    );
    
    final responseStream = chat.sendMessageStream(Content.text(message));
    
    await for (final chunk in responseStream) {
       yield chunk.text ?? '';
    }
  }
}
