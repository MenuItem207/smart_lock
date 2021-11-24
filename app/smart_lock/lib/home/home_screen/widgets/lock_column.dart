import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:smart_lock/globals/config/theme_data.dart';

import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/globals/widgets/lock.dart';

import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

// aniprops for multitween
enum _AniProps { pos, colorNormal, colorBreached }
final TimelineTween<_AniProps> _tween = TimelineTween<_AniProps>()
  ..addScene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 250))
      .animate(_AniProps.colorNormal, tween: ColorTween(begin: blue, end: blue))
  ..addScene(
          begin: const Duration(milliseconds: 0),
          duration: const Duration(milliseconds: 250))
      .animate(_AniProps.colorBreached,
          tween: ColorTween(begin: blue, end: Colors.red))
  ..addScene(
          begin: const Duration(milliseconds: 0),
          end: const Duration(milliseconds: 250))
      .animate(_AniProps.pos, tween: Tween<double>(begin: 0.0, end: 1.0));

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
                () => CustomAnimation<TimelineValue<_AniProps>>(
                    duration: const Duration(milliseconds: 150),
                    tween: _tween,
                    control: (handler.canOpen.value || handler.hasBreached)
                        ? CustomAnimationControl.play
                        : CustomAnimationControl.playReverse,
                    builder: (context, child, value) {
                      return Lock(
                        lockPosition: value.get(_AniProps.pos),
                        otherColor: value.get((handler.hasBreached)
                            ? _AniProps.colorBreached
                            : _AniProps.colorNormal),
                      );
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
