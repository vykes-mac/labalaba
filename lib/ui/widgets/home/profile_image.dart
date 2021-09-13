import 'package:flutter/material.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/ui/widgets/home/online_indicator.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final bool online;

  const ProfileImage({@required this.imageUrl, this.online = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126.0),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 126,
                    height: 126,
                    fit: BoxFit.fill,
                  )
                : Icon(
                    Icons.group_rounded,
                    size: 35,
                    color: kPrimary,
                  ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: online ? OnlineIndicator() : Container(),
          )
        ],
      ),
    );
  }
}
