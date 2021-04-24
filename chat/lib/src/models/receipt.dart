import 'package:flutter/foundation.dart';

enum ReceiptStatus { sent, deliverred, read }

extension EnumParsing on ReceiptStatus {
  String value() {
    return this.toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class Receipt {
  final String recipient;
  final String messageId;
  final ReceiptStatus status;
  final DateTime timestamp;
  String _id;
  String get id => _id;

  Receipt({
    @required this.recipient,
    @required this.messageId,
    @required this.status,
    @required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'recipient': this.recipient,
        'message_id': this.messageId,
        'status': status.value(),
        'timestamp': timestamp
      };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var receipt = Receipt(
        recipient: json['recipient'],
        messageId: json['message_id'],
        status: EnumParsing.fromString(json['status']),
        timestamp: json['timestamp']);
    receipt._id = json['id'];
    return receipt;
  }
}
