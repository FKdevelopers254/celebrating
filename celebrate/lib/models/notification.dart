class Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String senderId;
  final String recipientId;
  final DateTime createdAt;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.senderId,
    required this.recipientId,
    required this.createdAt,
    this.isRead = false,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'senderId': senderId,
      'recipientId': recipientId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}
