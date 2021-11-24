import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/globals/widgets/lock.dart';

import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

/// widget for column of widgets in the center of the home screen
class LockColumn extends StatelessWidget {
  const LockColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeScreenHandler handler = Get.find<HomeScreenHandler>();
    return Expanded(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 200),
          child: Material(
            color: Colors.transparent,
            child: Hero(
              tag: 'lock',
              child: Obx(
                () => CustomAnimation<double>(
                    duration: const Duration(milliseconds: 150),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    control: (handler.canOpen.value)
                        ? CustomAnimationControl.play
                        : CustomAnimationControl.playReverse,
                    builder: (context, child, value) {
                      return Lock(
                          lockPosition: value,
                          otherColor: Theme.of(context).highlightColor);
                    }),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              handler.deviceStatement,
              textAlign: TextAlign.center,
              style: sizeHandler.currentTextTheme.headline3,
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => handler.quickAction(),
              child: Text(
                handler.quickActionText,
                textAlign: TextAlign.center,
                style: sizeHandler.currentTextTheme.headline5,
              ),
            ),
            const SizedBox(height: 80)
          ],
        ),
      ],
    ));
  }
}
