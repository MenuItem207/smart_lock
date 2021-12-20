import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

/// widget for security centre
class SecurityCentreOverlay extends StatefulWidget {
  const SecurityCentreOverlay({Key? key}) : super(key: key);

  @override
  State<SecurityCentreOverlay> createState() => SecurityCentreOverlayState();
}

class SecurityCentreOverlayState extends State<SecurityCentreOverlay> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final HomeScreenHandler handler = Get.find<HomeScreenHandler>();
    return Expanded(
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
                        style: sizeHandler.currentTextTheme.bodyText1,
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
                            opacity: (handler.hasBreached.value) ? 1 : 0.25,
                            child: Text(
                              'resolve breach',
                              textScaleFactor: 1.0,
                              style: sizeHandler.currentTextTheme.headline5,
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
    );
  }
}
