import '../../domain/entities/message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_remote_datasource.dart';
import '../models/message_model.dart';
import '../models/chat_thread_model.dart';
import '../../core/security/encryption_service.dart';
import '../../core/security/app_encryption_helper.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource _remoteDatasource;
  final EncryptionService _encryption;

  ChatRepositoryImpl(this._remoteDatasource, this._encryption);

  @override
  Future<String> getAdminUid() {
    return _remoteDatasource.getAdminUid();
  }

  @override
  String generateThreadId(String userA, String userB, String type) {
    return _remoteDatasource.generateThreadId(userA, userB, type);
  }

  @override
  Future<void> ensureThread(ChatThread thread) async {
    final model = ChatThreadModel(
      id: thread.id,
      type: thread.type,
      participants: thread.participants,
      meta: thread.meta,
      createdAt: thread.createdAt,
      updatedAt: thread.updatedAt,
      lastMessage: thread.lastMessage,
      lastSenderUid: thread.lastSenderUid,
      lastSenderRole: thread.lastSenderRole,
      readStatus: thread.readStatus,
    );
    await _remoteDatasource.ensureThread(model);
  }

  @override
  Stream<List<ChatThread>> getMyThreads(String uid) {
    return _remoteDatasource.getMyThreads(uid);
  }

  @override
  Stream<List<Message>> getMessages(String threadId, {int limit = 50, DateTime? startAfter}) {
    // Return messages, decrypting text where applicable
    return _remoteDatasource.getMessages(threadId, limit: limit, startAfter: startAfter).asyncMap(
      (messages) async {
        final decrypted = <Message>[];
        for (final msg in messages) {
          if (msg.type == 'text') {
            try {
              if (msg.encryptedKey == 'aes-cbc-global') {
                final plaintext = AppEncryptionHelper.decrypt(msg.text);
                decrypted.add(msg.copyWith(text: plaintext));
              } else if (msg.encryptedKey != null && msg.encryptedKey!.isNotEmpty) {
                final plaintext = await _encryption.decryptMessage(
                    msg.text, msg.encryptedKey!);
                decrypted.add(msg.copyWith(text: plaintext));
              } else {
                decrypted.add(msg);
              }
            } catch (_) {
              decrypted.add(msg);
            }
          } else {
            decrypted.add(msg);
          }
        }
        return decrypted;
      },
    );
  }

  @override
  Future<void> sendMessage(String threadId, Message message) async {
    String textToSend = message.text;
    String? encryptedKey;

    // Only encrypt text-type messages
    if (message.type == 'text') {
      try {
        textToSend = AppEncryptionHelper.encrypt(message.text);
        encryptedKey = 'aes-cbc-global';
      } catch (_) {
        // If encryption fails, send as plaintext (graceful degradation)
      }
    }

    final model = MessageModel(
      id: message.id,
      senderId: message.senderId,
      senderRole: message.senderRole,
      text: textToSend,
      createdAt: message.createdAt,
      type: message.type,
      fileUrl: message.fileUrl,
      encryptedKey: encryptedKey,
    );
    await _remoteDatasource.sendMessage(threadId, model);
  }


  @override
  Future<void> markThreadAsRead(String threadId, String uid) async {
    await _remoteDatasource.markThreadAsRead(threadId, uid);
  }

  @override
  Future<void> markMessageAsRead(String threadId, String messageId) {
    return _remoteDatasource.markMessageAsRead(threadId, messageId);
  }

  @override
  Stream<int> getUnreadCount(String uid) {
    return _remoteDatasource.getUnreadCount(uid);
  }
}
