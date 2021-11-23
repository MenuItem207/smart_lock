import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';

/// widget for home
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            "Good Afternoon",
            style: sizeHandler.currentTextTheme.headline1,
          ),
        ],
      ),
    );
  }
}
