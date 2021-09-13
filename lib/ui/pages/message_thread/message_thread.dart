import 'dart:async';

import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/models/chat.dart';
import 'package:labalaba/models/local_message.dart';
import 'package:labalaba/states_management/home/chats_cubit.dart';
import 'package:labalaba/states_management/message/message_bloc.dart';
import 'package:labalaba/states_management/message_thread/message_thread_cubit.dart';
import 'package:labalaba/states_management/receipt/receipt_bloc.dart';
import 'package:labalaba/states_management/typing/typing_notification_bloc.dart';
import 'package:labalaba/theme.dart';
import 'package:labalaba/ui/widgets/message_thread/receiver_message.dart';
import 'package:labalaba/ui/widgets/message_thread/sender_message.dart';
import 'package:labalaba/ui/widgets/shared/header_status.dart';

class MessageThread extends StatefulWidget {
  final List<User> receivers;
  final User me;
  final Chat chat;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;

  MessageThread(this.receivers, this.me, this.messageBloc, this.chatsCubit,
      this.typingNotificationBloc, this.chat);

  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  String chatId = '';
  List<User> receivers;
  StreamSubscription _subscription;
  List<LocalMessage> messages = [];
  Timer _startTypingTimer;
  Timer _stopTypingTimer;

  @override
  void initState() {
    super.initState();
    chatId = widget.chat.id;
    receivers = widget.receivers;
    receivers.removeWhere((e) => e.id == widget.me.id);

    _updateOnMessageReceived();
    _updateOnReceiptReceived();
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.me));
    widget.typingNotificationBloc.add(
      TypingNotificationEvent.onSubscribed(widget.me,
          usersWithChat: receivers.map((e) => e.id).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: isLightTheme(context) ? Colors.black : Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(true);
                }),
            Expanded(
                child: BlocBuilder<TypingNotificationBloc,
                    TypingNotificationState>(
              bloc: widget.typingNotificationBloc,
              builder: (_, state) {
                String typing;
                if (state is TypingNotificationReceivedSuccess &&
                    state.event.event == Typing.start &&
                    state.event.chatId == chatId) {
                  if (widget.chat.type == ChatType.individual)
                    typing = 'typing...';
                  else
                    typing =
                        '${receivers.firstWhere((e) => e.id == state.event.from).username} is typing';
                }

                return HeaderStatus(
                  widget.chat.name ?? receivers.first.username,
                  widget.chat.type == ChatType.individual
                      ? receivers.first.photoUrl
                      : null,
                  widget.chat.type == ChatType.individual
                      ? receivers.first.active
                      : false,
                  description: widget.chat.type == ChatType.individual
                      ? 'last seen ${DateFormat.yMd().add_jm().format(receivers.first.lastseen)}'
                      : receivers
                          .fold<String>('', (p, e) => p + ', ' + e.username)
                          .replaceFirst(',', '')
                          .trim(),
                  typing: typing,
                );
              },
            ))
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(children: [
          Flexible(
            flex: 6,
            child: BlocBuilder<MessageThreadCubit, List<LocalMessage>>(
              builder: (__, messages) {
                this.messages = messages;
                if (this.messages.isEmpty)
                  return Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 30),
                    color: Colors.transparent,
                    child: widget.chat.type == ChatType.group
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Group created',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: Colors.white)),
                            ),
                          )
                        : Container(),
                  );
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToEnd());
                return _buildListOfMessages();
              },
            ),
          ),
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: isLightTheme(context) ? Colors.white : kAppBarDark,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -3),
                    blurRadius: 6.0,
                    color: Colors.black12,
                  ),
                ],
              ),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildMessageInput(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        height: 45.0,
                        width: 45.0,
                        child: RawMaterialButton(
                            fillColor: kPrimary,
                            shape: new CircleBorder(),
                            elevation: 5.0,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _sendMessage();
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  _buildListOfMessages() => ListView.builder(
        padding: EdgeInsets.only(top: 16, left: 16.0, bottom: 20),
        itemBuilder: (__, idx) {
          if (receivers.any((e) => e.id == messages[idx].message.from)) {
            _sendReceipt(messages[idx]);
            final receiver =
                receivers.firstWhere((e) => e.id == messages[idx].message.from);

            final String color = widget.chat.membersId
                ?.firstWhere((e) => e.containsKey(receiver.id))
                ?.values
                ?.first;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ReceiverMessage(
                messages[idx],
                receiver,
                widget.chat.type,
                color: ChatType.group == widget.chat.type
                    ? Color(int.tryParse(color))
                    : null,
              ),
            );
          } else {
            return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SenderMessage(messages[idx]));
          }
        },
        itemCount: messages.length,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
      );

  _buildMessageInput(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: isLightTheme(context)
          ? BorderSide.none
          : BorderSide(color: Colors.grey.withOpacity(0.3)),
    );

    return Focus(
      onFocusChange: (focus) {
        if (_startTypingTimer == null || (_startTypingTimer != null && focus))
          return;
        _stopTypingTimer?.cancel();
        _dispatchTyping(Typing.stop);
      },
      child: TextFormField(
        controller: _textEditingController,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: Theme.of(context).textTheme.caption,
        cursorColor: kPrimary,
        onChanged: _sendTypingNotification,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          enabledBorder: _border,
          filled: true,
          fillColor:
              isLightTheme(context) ? kPrimary.withOpacity(0.1) : kBubbleDark,
          focusedBorder: _border,
        ),
      ),
    );
  }

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) messageThreadCubit.messages(chatId);
    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await messageThreadCubit.viewModel.receivedMessage(state.message);
        final receipt = Receipt(
          recipient: state.message.from,
          messageId: state.message.id,
          status: ReceiptStatus.read,
          timestamp: DateTime.now(),
        );
        context.read<ReceiptBloc>().add(ReceiptEvent.onMessageSent(receipt));
      }
      if (state is MessageSentSuccess) {
        await messageThreadCubit.viewModel.sentMessage(state.message);
        widget.chatsCubit.chats();
      }
      if (chatId.isEmpty) chatId = messageThreadCubit.viewModel.chatId;
      messageThreadCubit.messages(chatId);
    });
  }

  void _updateOnReceiptReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.viewModel.updateMessageReceipt(state.receipt);
        messageThreadCubit.messages(chatId);
        widget.chatsCubit.chats();
      }
    });
  }

  _sendMessage() {
    if (_textEditingController.text.trim().isEmpty) return;

    final messages = receivers
        .map((e) => Message(
            groupId: widget.chat.type == ChatType.group ? widget.chat.id : null,
            from: widget.me.id,
            to: e.id,
            timestamp: DateTime.now(),
            contents: _textEditingController.text))
        .toList(); //create list of messages to all members of the group

    final sendMessageEvent = MessageEvent.onMessageSent(messages);
    widget.messageBloc.add(sendMessageEvent);

    _textEditingController.clear();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();

    _dispatchTyping(Typing.stop);
  }

  void _dispatchTyping(Typing event) {
    final chatid = widget.chat.type == ChatType.group ? chatId : widget.me.id;
    final typings = receivers
        .map((e) => TypingEvent(
            chatId: chatid, from: widget.me.id, to: e.id, event: event))
        .toList(); //create all typing events to users in group

    widget.typingNotificationBloc
        .add(TypingNotificationEvent.onTypingEventSent(typings));
  }

  void _sendTypingNotification(String text) {
    if (text.trim().isEmpty || messages.isEmpty) return;

    if (_startTypingTimer?.isActive ?? false) return;

    if (_stopTypingTimer?.isActive ?? false) _stopTypingTimer?.cancel();

    _dispatchTyping(Typing.start);

    _startTypingTimer =
        Timer(Duration(seconds: 5), () {}); //send one event every 5 seconds

    _stopTypingTimer =
        Timer(Duration(seconds: 6), () => _dispatchTyping(Typing.stop));
  }

  _scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  _sendReceipt(LocalMessage message) async {
    if (message.receipt == ReceiptStatus.read) return;
    final receipt = Receipt(
      recipient: message.message.from,
      messageId: message.id,
      status: ReceiptStatus.read,
      timestamp: DateTime.now(),
    );
    if (widget.chat.type == ChatType.individual)
      context.read<ReceiptBloc>().add(ReceiptEvent.onMessageSent(receipt));
    await context
        .read<MessageThreadCubit>()
        .viewModel
        .updateMessageReceipt(receipt);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _subscription?.cancel();
    _stopTypingTimer?.cancel();
    _startTypingTimer?.cancel();
    super.dispose();
  }
}
