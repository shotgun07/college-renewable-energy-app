class Message {
  final String id;
  final String senderId;
  final String senderRole; // 'student', 'teacher', 'admin'
  final String text;
  final String type; // 'text', 'image', 'voice', 'pdf'
  final String? fileUrl;
  final String? encryptedKey; // RSA-encrypted AES key for E2EE
  final bool isRead;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.text,
    this.type = 'text',
    this.fileUrl,
    this.encryptedKey,
    this.isRead = false,
    required this.createdAt,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? senderRole,
    String? text,
    String? type,
    String? fileUrl,
    String? encryptedKey,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderRole: senderRole ?? this.senderRole,
      text: text ?? this.text,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      encryptedKey: encryptedKey ?? this.encryptedKey,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
