import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:labalaba/colors.dart';

final appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.white,
);

final tabBarTheme = TabBarTheme(
  indicatorSize: TabBarIndicatorSize.label,
  unselectedLabelColor: Colors.black54,
  indicator: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: kPrimary,
  ),
);

final dividerTheme = DividerThemeData().copyWith(thickness: 1.0, indent: 75.0);

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
      primaryColor: kPrimary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme,
      tabBarTheme: tabBarTheme,
      dividerTheme: dividerTheme.copyWith(color: kIconLight),
      iconTheme: IconThemeData(color: kIconLight),
      textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
          .apply(displayColor: Colors.black),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: Colors.black,
    tabBarTheme: tabBarTheme.copyWith(unselectedLabelColor: Colors.white70),
    appBarTheme: appBarTheme.copyWith(backgroundColor: kAppBarDark),
    dividerTheme: dividerTheme.copyWith(color: kBubbleDark),
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
        .apply(displayColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity);

bool isLightTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light;
}
