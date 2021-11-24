import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final SizeHandler sizeHandler = Get.put(SizeHandler());

/// this class handlers the widget layout based on screen size
class SizeHandler {
  /// there are two widget layouts, wide and narrow
  RxBool isWide = false.obs;

  /// the current screen constraints
  late BoxConstraints constraints;

  /// updates the current screen constraints and isWide
  void updateSizeHandler(BoxConstraints constraints) {
    this.constraints = constraints;
    isWide.value = constraints.maxWidth >= constraints.maxHeight;
    currentTextTheme = (isWide.value) ? wideTheme : narrowTheme;
  }

  TextTheme currentTextTheme = wideTheme;

  /// text theme for wide screens
  static final TextTheme wideTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
      fontSize: 55,
      fontWeight: FontWeight.w200,
      color: Colors.white,
    ),
    headline2: GoogleFonts.montserrat(
      fontSize: 35,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headline3: GoogleFonts.montserrat(
      fontSize: 35,
      fontWeight: FontWeight.w200,
      color: Colors.white,
    ),
    headline4: GoogleFonts.montserrat(
      fontSize: 30,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headline5: GoogleFonts.montserrat(
      fontSize: 25,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyText1: GoogleFonts.montserrat(
      fontSize: 25,
      fontWeight: FontWeight.w200,
      color: Colors.white,
    ),
  );

  /// text theme for narrow screens
  static final TextTheme narrowTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
      fontSize: 55,
      fontWeight: FontWeight.w200,
      color: Colors.white,
    ),
    headline2: GoogleFonts.montserrat(
      fontSize: 35,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyText1: GoogleFonts.montserrat(
      fontSize: 25,
      fontWeight: FontWeight.w200,
      color: Colors.white,
    ),
  );
}
