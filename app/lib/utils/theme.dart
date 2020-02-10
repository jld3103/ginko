import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: public_member_api_docs
final Color lightColor = Color(0xFFFAFAFA);
// ignore: public_member_api_docs
final Color lightBackgroundColor = Color(0xFFF1F1F1);
// ignore: public_member_api_docs
final Color darkColor = Color(0xFF424242);
// ignore: public_member_api_docs
final Color darkBackgroundColor = Color(0xFF303030);

final _accentColor = Color(0xFF74B451);

/// Get the theme of the app
ThemeData get theme => ThemeData(
      brightness: Brightness.light,
      primaryColor: lightColor,
      accentColor: _accentColor,
      primaryIconTheme: IconThemeData(
        color: darkColor,
      ),
      textTheme: GoogleFonts.robotoTextTheme(),
      accentTextTheme: GoogleFonts.robotoTextTheme(),
      primaryTextTheme: GoogleFonts.robotoTextTheme(),
    );

/// Get the dark theme of the app
ThemeData get darkTheme => ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkColor,
      accentColor: _accentColor,
      highlightColor: Color(0xFF666666),
      primaryIconTheme: IconThemeData(
        color: Color(0xFFCCCCCC),
      ),
      textTheme: GoogleFonts.robotoTextTheme(),
      accentTextTheme: GoogleFonts.robotoTextTheme(),
      primaryTextTheme: GoogleFonts.robotoTextTheme(),
    );

/// Get the text color according to the theme
Color textColor(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.light
        ? darkColor
        : Color(0xFFCCCCCC);

/// Get the background color according to the theme
Color backgroundColor(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.light
        ? lightBackgroundColor
        : darkBackgroundColor;
