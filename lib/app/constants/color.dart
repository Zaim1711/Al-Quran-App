import 'package:flutter/material.dart';

const Color appGreen = Color(0xFF365E32);
const Color appGreenDark = Color.fromRGBO(11, 58, 7, 1);
const Color appGreenLight = Color(0xff81A263);
const Color appYellow = Color(0xffE7D37F);
const Color appOrange = Color(0xffFD9B63);
const Color appWhite = Color.fromRGBO(254, 251, 251, 0.991);

final ThemeData appLight = ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appGreenDark,
  ),
  primaryColor: appWhite,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: appGreen,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: appGreen,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appGreenDark,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appGreenDark,
    unselectedLabelColor: Colors.grey,
    indicatorColor: appGreenDark,
  ),
);

final ThemeData appDark = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appWhite,
  ),
  primaryColor: appGreen,
  scaffoldBackgroundColor: appGreenDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: appGreenDark,
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: appWhite,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appWhite,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appWhite,
    unselectedLabelColor: Colors.grey,
    indicatorColor: appWhite,
  ),
);
