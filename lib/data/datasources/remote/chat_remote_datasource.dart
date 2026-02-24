import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/message_model.dart';
import '../../models/chat_thread_model.dart';
import '../../../services/offline_service.dart';

class ChatRemoteDatasource {
  final FirebaseFirestore _firestore;
  final OfflineService _offlineService = OfflineService();
  String? _cachedAdminUid;

  ChatRemoteDatasource(this._firestore);

  FirebaseFirestore get firestore => _firestore;

  /// Get admin UID from config
  Future<String> getAdminUid() async {
    const fallback = 'ADMIN_UID_HERE';
    if (_cachedAdminUid != null && _cachedAdminUid!.trim().isNotEmpty) {
      return _cachedAdminUid!;
    }

    try {
      final source = _offlineService.isOnline ? Source.serverAndCache : Source.cache;
      final snap = await _firestore.collection('app_config').doc('chat').get(GetOptions(source: source));
      final data = snap.data();
      final v = (data?['adminUid'] ?? '').toString().trim();
      _cachedAdminUid = v.isEmpty ? fallback : v;
      return _cachedAdminUid!;
    } catch (_) {
      _cachedAdminUid = fallback;
      return _cachedAdminUid!;
    }
  }

  /// Generate thread ID
  String generateThreadId(String userA, String userB, String type) {
    final ids = [userA, userB]..sort();
    return '${type}_${ids[0]}_${ids[1]}';
  }

  /// Fetch a user's E2EE public key from Firestore
  Future<String?> getUserPublicKey(String uid) async {
    try {
      final source = _offlineService.isOnline ? Source.serverAndCache : Source.cache;
      final snap = await _firestore.collection('users').doc(uid).get(GetOptions(source: source));
      return snap.data()?['publicKey'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Ensure thread exists
  Future<void> ensureThread(ChatThreadModel thread) async {
    final ref = _firestore.collection('threads').doc(thread.id);
    final source = _offlineService.isOnline ? Source.serverAndCache : Source.cache;
    final snap = await ref.get(GetOptions(source: source));

    if (!snap.exists) {
      await ref.set(thread.toMap());
    } else {
      await ref.set({
        'updatedAt': FieldValue.serverTimestamp(),
        'meta': thread.meta,
      }, SetOptions(merge: true));
    }
  }

  /// Get user's threads
  Stream<List<ChatThreadModel>> getMyThreads(String uid) {
    return _firestore
        .collection('threads')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatThreadModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get messages for thread
  Stream<List<MessageModel>> getMessages(String threadId, {int limit = 50, DateTime? startAfter}) {
    var query = _firestore
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfter([Timestamp.fromDate(startAfter)]);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Send message
  Future<void> sendMessage(String threadId, MessageModel message) async {
    final threadRef = _firestore.collection('threads').doc(threadId);
    final msgRef = threadRef.collection('messages').doc();

    await _firestore.runTransaction((tx) async {
      tx.set(msgRef, message.toMap());

      tx.set(
        threadRef,
        {
          'updatedAt': FieldValue.serverTimestamp(),
          'lastMessage': message.type == 'text' 
              ? message.text 
              : (message.type == 'image' ? '📷 صورة' : '🎤 تسجيل صوتي'),
          'lastSenderUid': message.senderId,
          'lastSenderRole': message.senderRole,
        },
        SetOptions(merge: true),
      );
    });
  }

  /// Mark thread as read
  Future<void> markThreadAsRead(String threadId, String uid) async {
    final ref = _firestore.collection('threads').doc(threadId);
    await ref.set(
      {
        'read': {uid: FieldValue.serverTimestamp()}
      },
      SetOptions(merge: true),
    );
  }

  /// Mark specific message as read
  Future<void> markMessageAsRead(String threadId, String messageId) async {
    final msgRef = _firestore
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .doc(messageId);
        
    await msgRef.update({'isRead': true});
  }

  /// Get unread count
  Stream<int> getUnreadCount(String uid) {
    return getMyThreads(uid).map((threads) {
      int total = 0;
      for (final thread in threads) {
        if (thread.isUnread(uid)) total++;
      }
      return total;
    });
  }
}
