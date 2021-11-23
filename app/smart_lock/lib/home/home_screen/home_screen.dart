import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/globals/controllers/storage.dart';
import 'package:smart_lock/globals/widgets/lock.dart';
import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

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
            return Column(
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
                      Expanded(child: const SizedBox()),
                      Expanded(
                          child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 30, bottom: 200),
                            child: Lock(
                                lockPosition: 0,
                                otherColor: Theme.of(context).highlightColor),
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
                              Text(
                                handler.quickActionText,
                                textAlign: TextAlign.center,
                                style: sizeHandler.currentTextTheme.headline5,
                              ),
                              const SizedBox(height: 80)
                            ],
                          ),
                        ],
                      )),
                      Expanded(child: const SizedBox()),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
