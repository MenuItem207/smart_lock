import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/globals/controllers/storage.dart';
import 'package:smart_lock/home/home_screen/home_screen_handler.dart';
import 'package:smart_lock/home/home_screen/widgets/lock_column.dart';
import 'package:smart_lock/home/home_screen/widgets/options.dart';
import 'package:smart_lock/home/home_screen/widgets/overlay/overlay_screen.dart';
import 'package:smart_lock/home/home_screen/widgets/security_todo.dart';

/// widget for home
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenHandler handler = Get.put(HomeScreenHandler());
  final Storage storage = Get.find<Storage>();
  late var stream = FirebaseDatabase.instance
      .reference()
      .child("devices")
      .child(storage.id.value!);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Event>(
          stream: stream.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data?.snapshot.value != null) {
              var data = snapshot.data!.snapshot.value;
              handler.updateData(data);
            }
            return Obx(
              () => Stack(
                children: [
                  Column(
                    // used to listen to handler.state.value
                    mainAxisAlignment: (handler.state.value == LockState.locked)
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Text(
                          "Good Afternoon",
                          style: sizeHandler.currentTextTheme.headline1,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Options(),
                            LockColumn(),
                            SecurityTodo(),
                          ],
                        ),
                      )
                    ],
                  ),
                  const OverlayScreen(),
                ],
              ),
            );
          }),
    );
  }
}
