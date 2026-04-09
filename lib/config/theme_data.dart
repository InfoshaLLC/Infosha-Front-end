import 'package:flutter/material.dart';

import '../views/colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    cardColor: Color(0xE5E6EB).withOpacity(0.9),
    dividerColor: Colors.black,
    appBarTheme: AppBarTheme(
        color: Color.fromRGBO(255, 255, 255, 1),
        iconTheme: IconThemeData(color: Colors.black)),
  );
  static final dark = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backGroundColor,
      cardColor: backGroundColor,
      dividerColor: Colors.white,
      appBarTheme: AppBarTheme(color: backGroundColor),
      brightness: Brightness.dark);
}
