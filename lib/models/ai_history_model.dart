class AiHistoryItem {
  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;

  const AiHistoryItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  factory AiHistoryItem.fromJson(Map<String, dynamic> json) {
    return AiHistoryItem(
      id: json['_id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}