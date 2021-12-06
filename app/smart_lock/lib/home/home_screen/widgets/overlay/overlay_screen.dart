import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:smart_lock/globals/config/theme_data.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';
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
                  child: Obx(
                    () => CustomAnimation(
                        control: (handler.hasBreached.value)
                            ? CustomAnimationControl.play
                            : CustomAnimationControl.playReverse,
                        tween: ColorTween(
                            begin: themeData.focusColor.withOpacity(0.8),
                            end: themeData.errorColor.withOpacity(0.8)),
                        duration: const Duration(milliseconds: 250),
                        builder: (context, child, value) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  value as Color,
                                  themeData.highlightColor.withOpacity(0.8)
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                _OverlayTitle(),
                                _SecurityCentreOverlay(),
                              ],
                            ),
                          );
                        }),
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
              style: sizeHandler.currentTextTheme.headline1,
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

/// widget for security centre
class _SecurityCentreOverlay extends StatefulWidget {
  const _SecurityCentreOverlay({Key? key}) : super(key: key);

  @override
  State<_SecurityCentreOverlay> createState() => _SecurityCentreOverlayState();
}

class _SecurityCentreOverlayState extends State<_SecurityCentreOverlay> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenHandler>(
        init: Get.find<HomeScreenHandler>(),
        builder: (handler) {
          return (handler.overlayType.value == OverlayScreenType.security)
              ? Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 350,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                            itemCount: 10,
                            viewportFraction: 0.8,
                            scale: 0.9,
                            layout: SwiperLayout.STACK,
                            itemWidth: 350,
                            onIndexChanged: (value) => setState(() {
                              currentIndex = value;
                            }),
                          ),
                        ),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: constraints.maxHeight,
                            width: constraints.maxWidth * 0.33,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Timestamp:\n02/01/2020\nat 12:00',
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style:
                                        sizeHandler.currentTextTheme.bodyText1,
                                  ),
                                  const SizedBox(height: 50),
                                  GestureDetector(
                                    onTap: () {
                                      if (handler.hasBreached.value) {
                                        // if has breached, disable
                                        handler.resolveBreach();
                                      }
                                    },
                                    child: Obx(
                                      () => Opacity(
                                        opacity: (handler.hasBreached.value)
                                            ? 1
                                            : 0.25,
                                        child: Text(
                                          'resolve breach',
                                          textScaleFactor: 1.0,
                                          style: sizeHandler
                                              .currentTextTheme.headline5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                )
              : const SizedBox();
        });
  }
}
