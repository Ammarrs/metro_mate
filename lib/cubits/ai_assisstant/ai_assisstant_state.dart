import 'package:second/models/ai_model.dart';

abstract class AiAssistantState {
  final List<ChatMessage> messages;
  const AiAssistantState(this.messages);
}

class AiAssistantInitial extends AiAssistantState {
  const AiAssistantInitial() : super(const []);
}

// Emitted right after the user sends — triggers the typing bubble
class AiAssistantTyping extends AiAssistantState {
  const AiAssistantTyping(super.messages);
}

class AiAssistantLoaded extends AiAssistantState {
  const AiAssistantLoaded(super.messages);
}

class AiAssistantError extends AiAssistantState {
  final String error;
  const AiAssistantError(super.messages, this.error);
}