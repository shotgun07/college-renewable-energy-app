import '../entities/message.dart';
import '../entities/chat_thread.dart';

abstract class ChatRepository {

  Future<String> getAdminUid();


  String generateThreadId(String userA, String userB, String type);


  Future<void> ensureThread(ChatThread thread);


  Stream<List<ChatThread>> getMyThreads(String uid);


  Stream<List<Message>> getMessages(String threadId, {int limit = 50, DateTime? startAfter});


  Future<void> sendMessage(String threadId, Message message);


  Future<void> markThreadAsRead(String threadId, String uid);


  Future<void> markMessageAsRead(String threadId, String messageId);


  Stream<int> getUnreadCount(String uid);
}
