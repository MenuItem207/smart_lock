import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:smart_lock/globals/config/theme_data.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

/// widget for showing options
class Options extends StatelessWidget {
  const Options({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeScreenHandler handler = Get.find<HomeScreenHandler>();
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(top: constraints.maxHeight / 10, left: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Options',
                style: sizeHandler.currentTextTheme.headline2,
              ),
              const SizedBox(height: 25),
              _Entry(title: 'Passwords\nmanager', onTap: () {}),
              const SizedBox(height: 15),
              _Entry(title: 'Security\ncentre', onTap: () {}),
            ],
          ),
        );
      }),
    );
  }
}

/// widget for one options entry
class _Entry extends StatelessWidget {
  final String title;
  final Color secondColour;
  final Function onTap;
  const _Entry(
      {Key? key,
      required this.title,
      this.secondColour = blue,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 252,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Card(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gold,
                      secondColour,
                    ])),
            child: Text(
              title,
              style: sizeHandler.currentTextTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
