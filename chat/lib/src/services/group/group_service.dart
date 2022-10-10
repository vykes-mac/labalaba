import 'dart:async';

import 'package:chat/chat.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

abstract class IGroupService {
  Future<MessageGroup> create(MessageGroup group);
  Stream<MessageGroup> groups({required User me});
  dispose();
}

class MessageGroupService implements IGroupService {
  final Connection _connection;
  final RethinkDb r;

  final _controller = StreamController<MessageGroup>.broadcast();
  StreamSubscription? _changefeed;

  MessageGroupService(this.r, this._connection);

  @override
  Future<MessageGroup> create(MessageGroup group) async {
    Map record = await (r
            .table('message_groups')
            .insert(group.toJson(), {'return_changes': true}).run(_connection)
        as FutureOr<Map<dynamic, dynamic>>);

    return MessageGroup.fromJson(record['changes'].first['new_val']);
  }

  @override
  Stream<MessageGroup> groups({User? me}) {
    _startReceivingGroups(me);
    return _controller.stream;
  }

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  _startReceivingGroups(User? user) {
    _changefeed = r
        .table('message_groups')
        .filter(
          (group) => group('members')
              .contains(user!.id)
              .and(group('created_by').ne(user.id))
              .and(
                group
                    .hasFields('received_by')
                    .not()
                    .or(group('received_by').contains(user.id).not()),
              ),
        )
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;

                final group = _groupFromFeed(feedData);
                _controller.sink.add(group);
                _updateWhenReceivedGroupCreated(group, user);
              })
              .catchError((err) => print(err))
              .onError((dynamic error, stackTrace) => print(error));
        });
  }

  _updateWhenReceivedGroupCreated(MessageGroup group, User? user) async {
    Map updatedRecord = await (r.table('message_groups').get(group.id).update(
        (group) => r.branch(group.hasFields('received_by'), {
              'received_by': group('received_by').append(user!.id)
            }, {
              'received_by': [user.id]
            }),
        {'return_changes': 'always'}).run(_connection));
    _removeGroupWhenDeliverredToAll(updatedRecord['changes'][0]);
  }

  _removeGroupWhenDeliverredToAll(Map map) {
    final List members = map['new_val']['members'];
    final List alreadyReceived = map['new_val']['received_by'];
    final String? id = map['new_val']['id'];

    if (members.length > alreadyReceived.length) return;

    r
        .table('message_groups')
        .get(id)
        .delete({'return_changes': false}).run(_connection);
  }

  MessageGroup _groupFromFeed(feedData) {
    var data = feedData['new_val'];
    return MessageGroup.fromJson(data);
  }
}
