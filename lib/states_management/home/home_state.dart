import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSuccess extends HomeState {
  final List<User> onlineUsers;
  HomeSuccess(this.onlineUsers);

  @override
  List<Object> get props => [onlineUsers];
}
