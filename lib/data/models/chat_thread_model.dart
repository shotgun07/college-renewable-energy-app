import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_thread.dart';

class ChatThreadModel extends ChatThread {
  const ChatThreadModel({
    required super.id,
    required super.type,
    required super.participants,
    required super.meta,
    required super.createdAt,
    required super.updatedAt,
    required super.lastMessage,
    required super.lastSenderUid,
    required super.lastSenderRole,
    required super.readStatus,
  });

  factory ChatThreadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ChatThreadModel(
      id: doc.id,
      type: data['type'] as String? ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      meta: Map<String, dynamic>.from(data['meta'] ?? {}),
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
      lastMessage: data['lastMessage'] as String? ?? '',
      lastSenderUid: data['lastSenderUid'] as String? ?? '',
      lastSenderRole: data['lastSenderRole'] as String? ?? '',
      readStatus: _parseReadStatus(data['read']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'participants': participants,
      'meta': meta,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessage': lastMessage,
      'lastSenderUid': lastSenderUid,
      'lastSenderRole': lastSenderRole,
      'read': readStatus.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
    };
  }

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    return DateTime.now();
  }

  static Map<String, DateTime> _parseReadStatus(dynamic data) {
    if (data is! Map) return {};
    final map = Map<String, dynamic>.from(data);
    return map.map((k, v) => MapEntry(k, _toDateTime(v)));
  }
}
