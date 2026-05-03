import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/cubits/ai_assisstant/ai_assisstant_state.dart';
import 'package:second/models/ai_model.dart';
import '../../models/ai_history_model.dart';
import '../../services/ai_service.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  final AiService _service;

  AiAssistantCubit({AiService? service})
      : _service = service ?? AiService(),
        super(const AiAssistantInitial());

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      text: text,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    final updatedHistory = [...state.messages, userMsg];
    emit(AiAssistantTyping(updatedHistory));

    try {
      final reply = await _service.sendMessage(updatedHistory);

      final assistantMsg = ChatMessage(
        text: reply,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      );

      emit(AiAssistantLoaded([...updatedHistory, assistantMsg]));
    } catch (e) {
      emit(AiAssistantError(updatedHistory, e.toString()));
    }
  }

  Future<List<AiHistoryItem>> fetchHistory() => _service.fetchHistory();

  void clearHistory() => emit(const AiAssistantInitial());
}