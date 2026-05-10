class NotificationModel {
  final String title;
  final String message;
  final String sendAt;

  NotificationModel({
    required this.title,
    required this.message,
    required this.sendAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      message: json['message'],
      sendAt: json['sendAt'],
    );
  }
}
