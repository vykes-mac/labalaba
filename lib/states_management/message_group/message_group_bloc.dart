import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'message_group_event.dart';
part 'message_group_state.dart';

class MessageGroupBloc extends Bloc<MessageGroupEvent, MessageGroupState> {
  MessageGroupBloc(this._groupService) : super(MessageGroupState.initial());

  final IGroupService _groupService;
  StreamSubscription _subscription;

  @override
  Stream<MessageGroupState> mapEventToState(MessageGroupEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _groupService
          .groups(me: event.user)
          .listen((group) => add(_MessageGroupReceived(group)));
    }
    if (event is _MessageGroupReceived) {
      yield MessageGroupState.received(event.group);
    }
    if (event is MessageGroupCreated) {
      final group = await _groupService.create(event.group);
      yield MessageGroupState.created(group);
    }
  }

  @override
  Future<void> close() {
    print('dispose called');
    _subscription?.cancel();
    _groupService.dispose();
    return super.close();
  }
}
