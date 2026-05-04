import '../domain/entities/chat_thread.dart';
import '../domain/entities/message.dart';

class ChatService {
  Future<String> getOrCreateDirectThread(String uid1, String uid2, {Map<String, dynamic>? meta}) async => 'thread_id';
  Future<String?> adminThreadIdForStudent(String studentUid) async => 'admin_$studentUid';
  Future<String> adminUid() async => 'admin_id';
  Future<void> ensureThread({required String threadId, required String type, required List<String> participants, Map<String, dynamic>? meta}) async { }
  Future<void> markRead({required String threadId, required String uid}) async { }
  Future<void> sendMessage({required String threadId, required String text, required String senderId, required String senderRole, String? replyTo}) async { }
  
  Stream<List<ChatThread>> getMyThreads(String uid) => Stream.value([]);
  Stream<List<Message>> getMessages(String threadId, {int limit = 50}) => Stream.value([]);
  Stream<int> getUnreadCount(String uid) => Stream.value(0);
}