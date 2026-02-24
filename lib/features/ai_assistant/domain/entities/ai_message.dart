enum AiRole { user, model }

class AiMessage {
  final String content;
  final AiRole role;
  final DateTime timestamp;

  AiMessage({
    required this.content,
    required this.role,
    required this.timestamp,
  });
}
