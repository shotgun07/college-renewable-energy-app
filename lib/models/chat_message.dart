import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderUid;
  final String senderRole;
  final Timestamp? createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderUid,
    required this.senderRole,
    required this.createdAt,
  });

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return ChatMessage(
      id: doc.id,
      text: (d['text'] ?? '').toString(),
      senderUid: (d['senderUid'] ?? '').toString(),
      senderRole: (d['senderRole'] ?? '').toString(),
      createdAt: d['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderUid': senderUid,
      'senderRole': senderRole,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
