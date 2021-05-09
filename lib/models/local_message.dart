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
        ...message.toJson(),
        'receipt': receipt.value()
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['from'],
        to: json['to'],
        contents: json['contents'],
        timestamp: json['timestamp']);

    final localMessage = LocalMessage(
        json['chat_id'], message, EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }
}
