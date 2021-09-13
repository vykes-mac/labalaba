import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/models/chat.dart';
import 'package:labalaba/models/local_message.dart';
import 'package:labalaba/theme.dart';

class ReceiverMessage extends StatelessWidget {
  final User _user;
  final LocalMessage _message;
  final ChatType type;
  final Color color;
  const ReceiverMessage(this._message, this._user, this.type, {Color color})
      : this.color = color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.75,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == ChatType.group)
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, bottom: 2.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _user.username, //add username to chat bubble
                        softWrap: true,
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isLightTheme(context) ? kBubbleLight : kBubbleDark,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  position: DecorationPosition.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      _message.message.contents.trim(),
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(height: 1.2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      DateFormat('h:mm a').format(_message.message.timestamp),
                      style: Theme.of(context).textTheme.overline.copyWith(
                          color: isLightTheme(context)
                              ? Colors.black54
                              : Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor:
                isLightTheme(context) ? Colors.white : Colors.black,
            radius: 18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(_user.photoUrl,
                  width: 30, height: 30, fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }
}
