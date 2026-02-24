import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String threadIdFor(String a, String b, String type) {
    final ids = [a, b]..sort();
    return '${type}_${ids[0]}_${ids[1]}';
  }

  String? _cachedAdminUid;

  Future<String> adminUid() async {
    const fallback = 'ADMIN_UID_HERE';
    if (_cachedAdminUid != null && _cachedAdminUid!.trim().isNotEmpty) return _cachedAdminUid!;

    try {
      final snap = await _db.collection('app_config').doc('chat').get();
      final data = snap.data();
      final v = (data?['adminUid'] ?? '').toString().trim();
      _cachedAdminUid = v.isEmpty ? fallback : v;
      return _cachedAdminUid!;
    } catch (_) {
      _cachedAdminUid = fallback;
      return _cachedAdminUid!;
    }
  }

  Future<String> adminThreadIdForStudent(String studentUid) async {
    final a = await adminUid();
    return threadIdFor(studentUid, a, 'admin_user');
  }

  Future<void> ensureThread({
    required String threadId,
    required String type,
    required List<String> participants,
    Map<String, dynamic>? meta,
  }) async {
    final ref = _db.collection('threads').doc(threadId);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'type': type,
        'participants': participants,
        'meta': meta ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastSenderUid': '',
        'lastSenderRole': '',
        'read': <String, dynamic>{},
      });
    } else {
      await ref.set({
        'updatedAt': FieldValue.serverTimestamp(),
        if (meta != null) 'meta': meta,
      }, SetOptions(merge: true));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMyThreads(String uid) {
    return _db
        .collection('threads')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchMessages(String threadId) {
    return _db
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String threadId,
    required String text,
    required String senderId,
    required String senderRole,
  }) async {
    final t = text.trim();
    if (t.isEmpty) return;

    final threadRef = _db.collection('threads').doc(threadId);
    final msgRef = threadRef.collection('messages').doc();

    await _db.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': senderId,
        'senderRole': senderRole,
        'text': t,
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.set(
        threadRef,
        {
          'updatedAt': FieldValue.serverTimestamp(),
          'lastMessage': t,
          'lastSenderUid': senderId,
          'lastSenderRole': senderRole,
        },
        SetOptions(merge: true),
      );
    });
  }

  Future<void> markRead({required String threadId, required String uid}) async {
    final ref = _db.collection('threads').doc(threadId);
    await ref.set(
      {
        'read': {uid: FieldValue.serverTimestamp()}
      },
      SetOptions(merge: true),
    );
  }

  int unreadCountFromThreadDoc(Map<String, dynamic> t, String uid) {
    final updatedAt = t['updatedAt'];
    if (updatedAt is! Timestamp) return 0;

    final updated = updatedAt.toDate();
    final readMap = (t['read'] is Map) ? (t['read'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final readAt = readMap[uid];

    if (readAt is! Timestamp) return 1;
    final readTime = readAt.toDate();

    return updated.isAfter(readTime) ? 1 : 0;
  }

  Stream<int> watchUnreadCount(String uid) {
    return watchMyThreads(uid).map((snap) {
      int total = 0;
      for (final d in snap.docs) {
        total += unreadCountFromThreadDoc(d.data(), uid);
      }
      return total;
    });
  }

  Future<String> getOrCreateDirectThread(String otherUid, String otherRole, {Map<String, dynamic>? meta}) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) throw Exception("User not logged in");

    final threadId = threadIdFor(currentUid, otherUid, otherRole == 'admin' ? 'admin_user' : 'teacher_student');
    
    await ensureThread(
      threadId: threadId,
      type: otherRole == 'admin' ? 'admin_user' : 'teacher_student',
      participants: [currentUid, otherUid],
      meta: meta,
    );

    return threadId;
  }
}
