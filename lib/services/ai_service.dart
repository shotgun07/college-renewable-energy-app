import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../env/env.dart';

class AiService {
  static final String _apiKey = Env.geminiApiKey;
  
  late final GenerativeModel _model;
  ChatSession? _chatSession;

  AiService() {
    if (_apiKey.isEmpty) {
      debugPrint('Warning: GEMINI_API_KEY is not set. AI Features will mock or fail.');
    }
    

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      // نعطي المساعد الذكي شخصية احترافية ليجيب كمرشد وخبير لمنصة الطاقة المتجددة
      systemInstruction: Content.system(
        "أنت مساعد ذكي مخصص لمنصة كلية الطاقات المتجددة. "
        "مهمتك مساعدة الطلاب والمحاضرين والإجابة على استفساراتهم حول النظام، الكورسات، أو معلومات حول  الطاقات المتجددةوالبيئه والict البديلة. "
        "أجب باللغة العربية بشكل احترافي، دقيق، ومختصر."
      ),
    );
  }

  Future<String> sendMessage(String text) async {
    if (_apiKey.isEmpty) {
      await Future.delayed(const Duration(seconds: 1)); 
      return "عذراً، لم يقم المسؤول عن النظام بإعداد مفتاح API الخاص بـ Gemini AI بعد. المرجو إضافة المفتاح ليعمل الذكاء الاصطناعي بشكل كامل.";
    }

    try {
      _chatSession ??= _model.startChat();
      
      final response = await _chatSession!.sendMessage(Content.text(text));
      
      return response.text ?? "عذراً، لم أتمكن من صياغة إجابة مناسبة. هل يمكنك إعادة صياغة سؤالك؟";
    } catch (e) {
      debugPrint("AI Service Error: $e");
      throw Exception("فشل الاتصال بخدمات الذكاء الاصطناعي، يرجى المحاولة مجدداً لاحقاً.");
    }
  }
}