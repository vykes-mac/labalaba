import 'dart:async';

import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class MessageService implements IMessageService {
  final Connection? _connection;
  final RethinkDb r;
  final IEncryption? _encryption;

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _changefeed;

  MessageService(this.r, this._connection, {IEncryption? encryption})
      : _encryption = encryption;

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<Message> send(List<Message> messages) async {
    final data = messages.map((message) {
      var data = message.toJson();
      if (_encryption != null)
        data['contents'] = _encryption!.encrypt(message.contents);
      return data;
    }).toList();

    Map record = await (r
        .table('messages')
        .insert(data, {'return_changes': true}).run(_connection!));
    return Message.fromJson(record['changes'].first['new_val']);
  }

  _startReceivingMessages(User user) {
    _changefeed = r
        .table('messages')
        .filter({'to': user.id})
        .changes({'include_initial': true})
        .run(_connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;

                final message = _messageFromFeed(feedData);
                _controller.sink.add(message);
                _removeDeliverredMessage(message);
              })
              .catchError((err) => print(err))
              .onError((dynamic error, stackTrace) => print(error));
        });
  }

  Message _messageFromFeed(feedData) {
    var data = feedData['new_val'];
    if (_encryption != null)
      data['contents'] = _encryption!.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  _removeDeliverredMessage(Message message) {
    r
        .table('messages')
        .get(message.id)
        .delete({'return_changes': false}).run(_connection!);
  }
}
