// Modelo de Mensaje
class Message {
  final int id;
  final String senderEmail;
  final String receiverEmail;
  final String title;
  final String body;
  final DateTime sentAt;

  Message({
    required this.id,
    required this.senderEmail,
    required this.receiverEmail,
    required this.title,
    required this.body,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderEmail: json['sender_email'],
      receiverEmail: json['receiver_email'],
      title: json['title'],
      body: json['body'],
      sentAt: DateTime.parse(json['sent_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_email': senderEmail,
      'receiver_email': receiverEmail,
      'title': title,
      'body': body,
      'sent_at': sentAt.toIso8601String(),
    };
  }
}
