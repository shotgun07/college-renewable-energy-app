import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.senderRole,
    required super.text,
    required super.createdAt,
    super.type = 'text',
    super.fileUrl,
    super.encryptedKey,
    super.encryptedContent,
    super.isRead = false,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      senderRole: data['senderRole'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdAt: _toDateTime(data['createdAt']),
      type: data['type'] as String? ?? 'text',
      fileUrl: data['fileUrl'] as String?,
      encryptedKey: data['encryptedKey'] as String?,
      encryptedContent: data['encryptedContent'] as String?,
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderRole': senderRole,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type,
      'isRead': isRead,
      if (fileUrl != null) 'fileUrl': fileUrl,
      if (encryptedKey != null) 'encryptedKey': encryptedKey,
      if (encryptedContent != null) 'encryptedContent': encryptedContent,
    };
  }

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    return DateTime.now();
  }
}
