import 'package:chat/chat.dart';

class LocalMessage {
  String chatId;
  String get id => _id;
  String _id;
  Message message;
  ReceiptStatus receipt;

  LocalMessage(this.chatId, this.message, this.receipt);

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'id': message.id,
        'sender': message.from,
        'receiver': message.to,
        'contents': message.contents,
        'receipt': receipt.value(),
        'received_at': message.timestamp.toString()
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['sender'],
        to: json['receiver'],
        contents: json['contents'],
        timestamp: DateTime.parse(json['received_at']));

    final localMessage = LocalMessage(
        json['chat_id'], message, EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }
}
