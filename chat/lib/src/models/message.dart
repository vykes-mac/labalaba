import 'package:flutter/foundation.dart';

class Message {
  String get id => _id;
  final String from;
  final String to;
  final DateTime timestamp;
  final String contents;
  String _id;
  String groupId;

  Message(
      {@required this.from,
      @required this.to,
      @required this.timestamp,
      @required this.contents,
      this.groupId});

  toJson() => {
        'from': this.from,
        'to': this.to,
        'timestamp': this.timestamp,
        'contents': this.contents,
        'group_id': this.groupId
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
        from: json['from'],
        to: json['to'],
        contents: json['contents'],
        timestamp: json['timestamp'],
        groupId: json['group_id']);

    message._id = json['id'];
    return message;
  }
}
