enum MessageRole { user, assistant }

class ChatMessage {
  final String text;
  final MessageRole role;
  final DateTime createdAt;

  const ChatMessage({
    required this.text,
    required this.role,
    required this.createdAt,
  });
}