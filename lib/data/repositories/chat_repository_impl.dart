import '../../domain/entities/message.dart';
import '../../domain/entities/chat_thread.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_remote_datasource.dart';
import '../models/message_model.dart';
import '../models/chat_thread_model.dart';
import '../../core/security/encryption_service.dart';

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
    return _remoteDatasource.getMessages(threadId, limit: limit, startAfter: startAfter).asyncMap(
      (messages) async {
        final decrypted = <Message>[];
        for (final msg in messages) {
          if (msg.type == 'text') {
            try {
              if (msg.encryptedKey != null && msg.encryptedKey!.isNotEmpty) {
                final ciphertext = msg.encryptedContent ?? msg.text;
                final plaintext = await _encryption.decryptMessage(
                    ciphertext, msg.encryptedKey!);
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
    String? encryptedContent;

    if (message.type == 'text') {
      String receiverId = '';
      final parts = threadId.split('_');
      if (parts.length >= 3) {
         receiverId = parts[1] == message.senderId ? parts[2] : parts[1];
      } else {
         final threadDoc = await _remoteDatasource.firestore.collection('threads').doc(threadId).get();
         final participants = List<String>.from(threadDoc.data()?['participants'] ?? []);
         receiverId = participants.firstWhere((id) => id != message.senderId, orElse: () => '');
      }

      if (receiverId.isEmpty) {
         throw Exception('Could not determine receiver ID from threadId');
      }

      final receiverPublicKey = await _remoteDatasource.getUserPublicKey(receiverId);
      if (receiverPublicKey == null || receiverPublicKey.isEmpty) {
        throw Exception('Receiver public key not found');
      }

      final encryptionResult = _encryption.encryptMessage(message.text, receiverPublicKey);
      if (encryptionResult.isEmpty || encryptionResult['content']!.isEmpty) {
        throw Exception('Encryption returned empty result');
      }

      encryptedContent = encryptionResult['content'];
      encryptedKey = encryptionResult['key'];
      textToSend = ''; 
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
      encryptedContent: encryptedContent,
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
