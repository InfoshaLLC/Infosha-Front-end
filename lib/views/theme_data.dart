import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      primaryColor: Colors.black,
      dividerColor: Colors.black,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: primaryColor),
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: primaryColor)),
      textTheme: GoogleFonts.montserratTextTheme(
          // Theme.of(context).textTheme,
          ));
  static final dark = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backGroundColor,
      cardColor: bgColor,
      dividerColor: Colors.white,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: primaryColor),
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      textTheme: GoogleFonts.montserratTextTheme(
          // Theme.of(context).textTheme,
          ),
      brightness: Brightness.dark);
}
