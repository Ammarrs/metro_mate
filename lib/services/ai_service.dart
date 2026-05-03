import 'package:second/models/ai_model.dart';

import '../config/api_config.dart';
import '../models/ai_history_model.dart';
import 'api_client.dart';

class AiService {
  final ApiClient _client = ApiClient();

  Future<String> sendMessage(List<ChatMessage> history) async {
    final question = history.last.text;

    final response = await _client.post(
      ApiConfig.aiChatEndpoint,
      data: {'question': question},
    );

    return response.data['data']['answer'] as String;
  }


  Future<List<AiHistoryItem>> fetchHistory() async {
    final response = await _client.get(ApiConfig.aiChatHistoryEndpoint);

    final list = response.data['data']['History'] as List<dynamic>;
    return list
        .map((e) => AiHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}