part of 'typing_notification_bloc.dart';

abstract class TypingNotificationState extends Equatable {
  const TypingNotificationState();
  factory TypingNotificationState.initial() => TypingNotificatoinInitial();
  factory TypingNotificationState.sent() => TypingNotificationSentSuccess();
  factory TypingNotificationState.received(TypingEvent event) =>
      TypingNotificationReceivedSuccess(event);

  @override
  List<Object> get props => [];
}

class TypingNotificatoinInitial extends TypingNotificationState {}

class TypingNotificationSentSuccess extends TypingNotificationState {}

class TypingNotificationReceivedSuccess extends TypingNotificationState {
  final TypingEvent event;
  const TypingNotificationReceivedSuccess(this.event);

  @override
  List<Object> get props => [event];
}
