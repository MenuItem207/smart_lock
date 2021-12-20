import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smart_lock/globals/config/theme_data.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';

import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

// widget for passwords manager
class PasswordsManagerOverlay extends StatefulWidget {
  const PasswordsManagerOverlay({Key? key}) : super(key: key);

  @override
  State<PasswordsManagerOverlay> createState() =>
      _PasswordsManagerOverlayState();
}

class _PasswordsManagerOverlayState extends State<PasswordsManagerOverlay> {
  String newPassword = '';
  @override
  Widget build(BuildContext context) {
    final HomeScreenHandler handler = Get.find<HomeScreenHandler>();
    return Expanded(
        child: Column(
      children: [
        TextField(
          onSubmitted: (text) {
            newPassword = text;
          },
          onChanged: (text) {
            newPassword = text;
          },
          style: sizeHandler.currentTextTheme.headline1,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'New Password',
            hintStyle: sizeHandler.currentTextTheme.headline6,
            contentPadding:
                const EdgeInsets.only(bottom: 10, top: 25, right: 30, left: 30),
          ),
          cursorWidth: 3,
          cursorRadius: const Radius.circular(3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => handler.addTemporaryPassword(newPassword),
              child: Text('Add temporary password',
                  style: sizeHandler.currentTextTheme.bodyText2),
            ),
            const SizedBox(
              width: 30,
            ),
            GestureDetector(
              onTap: () => handler.modifyDefaultPassword(newPassword),
              child: Text('Update password',
                  style: sizeHandler.currentTextTheme.bodyText2),
            ),
          ],
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.only(top: 25),
              itemCount: handler.passwords.value.length,
              itemBuilder: (context, index) => Center(
                child: SizedBox(
                  height: 50,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(handler.passwords.value[index],
                            style: sizeHandler.currentTextTheme.bodyText1),
                        GestureDetector(
                          onTap: () => handler.deletePassword(index),
                          child: Icon(
                            Icons.close_rounded,
                            size: 25,
                            color: (index == 0) ? Colors.transparent : white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
