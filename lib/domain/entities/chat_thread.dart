class ChatThread {
  final String id;
  final String type; // 'student_teacher', 'admin_user', etc.
  final List<String> participants;
  final Map<String, dynamic> meta; // department, names, etc.
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastMessage;
  final String lastSenderUid;
  final String lastSenderRole;
  final Map<String, DateTime> readStatus; // uid -> last read time

  const ChatThread({
    required this.id,
    required this.type,
    required this.participants,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
    required this.lastSenderUid,
    required this.lastSenderRole,
    required this.readStatus,
  });

  ChatThread copyWith({
    String? id,
    String? type,
    List<String>? participants,
    Map<String, dynamic>? meta,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessage,
    String? lastSenderUid,
    String? lastSenderRole,
    Map<String, DateTime>? readStatus,
  }) {
    return ChatThread(
      id: id ?? this.id,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderUid: lastSenderUid ?? this.lastSenderUid,
      lastSenderRole: lastSenderRole ?? this.lastSenderRole,
      readStatus: readStatus ?? this.readStatus,
    );
  }

  bool isUnread(String uid) {
    final lastRead = readStatus[uid];
    if (lastRead == null) return true;
    return updatedAt.isAfter(lastRead);
  }
}
