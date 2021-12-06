import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:smart_lock/globals/config/theme_data.dart';
import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

/// widget for displaying passwords manager or security centre
class OverlayScreen extends StatelessWidget {
  const OverlayScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenHandler>(
      builder: (handler) => IgnorePointer(
        ignoring: (handler.overlayType.value == OverlayScreenType.none),
        child: CustomAnimation<double>(
            control: (handler.overlayType.value == OverlayScreenType.none)
                ? CustomAnimationControl.playReverse
                : CustomAnimationControl.play,
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 250),
            builder: (context, child, value) {
              return Opacity(
                opacity: value,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeData.focusColor.withOpacity(0.8),
                          themeData.highlightColor.withOpacity(0.8)
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        _OverlayTitle(),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

// type of overlay
enum OverlayScreenType {
  passwords,
  security,
  none,
}

/// widget for title and close button
class _OverlayTitle extends StatelessWidget {
  const _OverlayTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeScreenHandler handler = Get.find<HomeScreenHandler>();
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              titleFromType[handler.overlayType.value],
              textScaleFactor: 1.0,
              style: themeData.textTheme.headline3,
            ),
          ),
          GestureDetector(
            onTap: () => handler.hideOverlay(),
            child: Icon(
              Icons.close_rounded,
              size: 45,
              color: themeData.primaryColor,
            ),
          )
        ],
      ),
    );
  }

  static Map titleFromType = {
    OverlayScreenType.passwords: 'Password Manager',
    OverlayScreenType.security: 'Security Centre',
    OverlayScreenType.none: '',
  };
}
