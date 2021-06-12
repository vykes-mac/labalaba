import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Loading extends OnboardingState {
  @override
  List<Object> get props => [];
}

class OnboardingSuccess extends OnboardingState {
  final User _user;

  OnboardingSuccess(this._user);
  @override
  List<Object> get props => [_user];
}
