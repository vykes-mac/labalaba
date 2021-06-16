import 'package:flutter/material.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/theme.dart';
import 'package:labalaba/ui/widgets/home/profile_image.dart';

class Chats extends StatefulWidget {
  const Chats();

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, indx) => _chatItem(),
        separatorBuilder: (_, __) => Divider(),
        itemCount: 3);
  }

  _chatItem() => ListTile(
        contentPadding: EdgeInsets.only(left: 16.0),
        leading: ProfileImage(
          imageUrl: "https://picsum.photos/seed/picsum/200/300",
          online: true,
        ),
        title: Text(
          'Lisa',
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: Text(
          'Thank you so much',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.overline.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70,
              ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '12pm',
              style: Theme.of(context).textTheme.overline.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  color: kPrimary,
                  alignment: Alignment.center,
                  child: Text(
                    '2',
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}
