import 'dart:async';

import 'package:chat/chat.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class TypingNotification implements ITypingNotification {
  final Connection? _connection;
  final RethinkDb _r;

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _changefeed;
  IUserService? _userService;

  TypingNotification(this._r, this._connection, this._userService);

  @override
  Future<bool?> send({required List<TypingEvent> events}) async {
    final receivers =
        await _userService!.fetch(events.map((e) => e.to).toList());
    if (receivers.isEmpty) return false;
    events
        .retainWhere((event) => receivers.map((e) => e.id).contains(event.to));
    final data = events.map((e) => e.toJson()).toList();
    Map record = await (_r
        .table('typing_events')
        .insert(data, {'conflict': 'update'}).run(_connection!));
    return record['inserted'] >= 1;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String?> userIds) {
    _startReceivingTypingEvents(user, userIds);
    return _controller.stream;
  }

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  _startReceivingTypingEvents(User user, List<String?> userIds) {
    _changefeed = _r
        .table('typing_events')
        .filter((event) {
          return event('to')
              .eq(user.id)
              .and(_r.expr(userIds).contains(event('from')));
        })
        .changes({'include_initial': true})
        .run(_connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;

                final typing = _eventFromFeed(feedData);
                _controller.sink.add(typing);
                _removeEvent(typing);
              })
              .catchError((err) => print(err))
              .onError((dynamic error, stackTrace) => print(error));
        });
  }

  TypingEvent _eventFromFeed(feedData) {
    return TypingEvent.fromJson(feedData['new_val']);
  }

  _removeEvent(TypingEvent event) {
    _r.table('typing_events').filter({'chat_id': event.chatId}).delete(
        {'return_changes': false}).run(_connection!);
  }
}
