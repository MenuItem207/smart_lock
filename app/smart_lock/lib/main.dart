import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/get_navigation.dart';

import 'package:smart_lock/globals/config/theme_data.dart';
import 'package:smart_lock/globals/config/scroll_behaviour.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/globals/controllers/storage.dart';

import 'package:smart_lock/home/home_screen/home_screen.dart';
import 'package:smart_lock/home/login/login_screen.dart';

void main() async {
  await Storage.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Smart Lock',
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: ScrollBehaviour(),
            child: child!,
          );
        },
        theme: themeData,
        home: LayoutBuilder(builder: (context, constraints) {
          sizeHandler.updateSizeHandler(constraints);
          return Obx(
            () => (Get.find<Storage>().id.value == null)
                ? const LoginScreen()
                : const HomeScreen(),
          );
        }));
  }
}
