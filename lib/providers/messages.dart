class Messages {
  final String senderId;
  final String receiverId;
  final DateTime sentTime;
  final MessageType messagetype;
  final String content;

  const Messages(
      {required this.messagetype,
      required this.receiverId,
      required this.senderId,
      required this.sentTime,
      required this.content});

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        sentTime: json['sentTime'].toDate(),
        content: json['content'],
        messagetype: MessageType.fromJson(json['messageType']),
      );

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'sentTime': sentTime,
        'content': content,
        'messageType': messagetype.toJson()
      };
}

enum MessageType {
  text,
  image;

  String toJson() => name;
  factory MessageType.fromJson(String json) => values.byName(json);
}
