import '../entities/message.dart';
import '../entities/chat_thread.dart';

abstract class ChatRepository {
  /// Get admin UID from config
  Future<String> getAdminUid();

  /// Generate deterministic thread ID
  String generateThreadId(String userA, String userB, String type);

  /// Create or update thread
  Future<void> ensureThread(ChatThread thread);

  /// Get user's chat threads
  Stream<List<ChatThread>> getMyThreads(String uid);

  /// Get messages for a thread
  Stream<List<Message>> getMessages(String threadId, {int limit = 50, DateTime? startAfter});

  /// Send a message
  Future<void> sendMessage(String threadId, Message message);

  /// Mark thread as read
  Future<void> markThreadAsRead(String threadId, String uid);

  /// Mark specific message as read
  Future<void> markMessageAsRead(String threadId, String messageId);

  /// Get total unread count
  Stream<int> getUnreadCount(String uid);
}
