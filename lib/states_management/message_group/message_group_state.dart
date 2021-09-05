part of 'message_group_bloc.dart';

abstract class MessageGroupState extends Equatable {
  const MessageGroupState();
  factory MessageGroupState.initial() => MessageGroupInitial();
  factory MessageGroupState.created(MessageGroup group) =>
      MessageGroupCreatedSuccess(group);
  factory MessageGroupState.received(MessageGroup group) =>
      MessageGroupReceived(group);
  @override
  List<Object> get props => [];
}

class MessageGroupInitial extends MessageGroupState {}

class MessageGroupCreatedSuccess extends MessageGroupState {
  const MessageGroupCreatedSuccess(this.group);

  final MessageGroup group;

  @override
  List<Object> get props => [group];
}

class MessageGroupReceived extends MessageGroupState {
  const MessageGroupReceived(this.group);

  final MessageGroup group;

  @override
  List<Object> get props => [group];
}
