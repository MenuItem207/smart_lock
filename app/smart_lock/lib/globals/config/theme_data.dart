import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// global theme data
final ThemeData themeData = ThemeData(
  primaryColor: _backgroundColour,
  scaffoldBackgroundColor: _backgroundColour,
  highlightColor: blue,
  focusColor: gold,
  errorColor: red,
  textTheme: TextTheme(
    headline1: GoogleFonts.montserrat(
      fontSize: 55,
      fontWeight: FontWeight.w200,
      color: _white,
    ),
    headline2: GoogleFonts.montserrat(
      fontSize: 35,
      fontWeight: FontWeight.w500,
      color: _white,
    ),
    bodyText1: GoogleFonts.montserrat(
      fontSize: 25,
      fontWeight: FontWeight.w200,
      color: _white,
    ),
  ),
);

const Color _backgroundColour = Color(0xFF2C2F36);
const Color blue = Color(0xFF5E83BA);
const Color gold = Color(0xFFBA8A5E);
const Color red = Color(0xFFEB6D6D);
const Color _white = Color(0xFFFFFFFF);
