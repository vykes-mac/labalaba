part of 'message_group_bloc.dart';

abstract class MessageGroupEvent extends Equatable {
  const MessageGroupEvent();
  factory MessageGroupEvent.onSubscribed(User user) => Subscribed(user);
  factory MessageGroupEvent.onGroupCreated(MessageGroup group) =>
      MessageGroupCreated(group);

  @override
  List<Object> get props => [];
}

class Subscribed extends MessageGroupEvent {
  final User user;
  const Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class MessageGroupCreated extends MessageGroupEvent {
  final MessageGroup group;
  const MessageGroupCreated(this.group);

  @override
  List<Object> get props => [group];
}

class _MessageGroupReceived extends MessageGroupEvent {
  const _MessageGroupReceived(this.group);

  final MessageGroup group;

  @override
  List<Object> get props => [group];
}
