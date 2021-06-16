import 'package:flutter/material.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/theme.dart';

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
        color: kIndicatorBubble,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 3.0,
          color: isLightTheme(context) ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
