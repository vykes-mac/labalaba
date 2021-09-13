import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:labalaba/models/chat.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(
      BuildContext context, List<User> receivers, User me, Chat chat);
  Future<void> onShowCreateGroup(
      BuildContext context, List<User> activeUsers, User me);
}

class HomeRouter implements IHomeRouter {
  final Widget Function(List<User> receivers, User me, Chat chat)
      showMessageThread;

  final Widget Function(List<User> activeUsers, User me) showCreatedGroup;

  HomeRouter(
      {@required this.showMessageThread, @required this.showCreatedGroup});

  @override
  Future<void> onShowMessageThread(
      BuildContext context, List<User> receivers, User me, Chat chat) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receivers, me, chat),
      ),
    );
  }

  @override
  Future<void> onShowCreateGroup(
      BuildContext context, List<User> activeUsers, User me) async {
    showCupertinoModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => showCreatedGroup(activeUsers, me),
    );
  }
}
