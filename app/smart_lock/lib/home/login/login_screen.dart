import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/globals/controllers/storage.dart';
import 'package:smart_lock/globals/widgets/lock.dart';

/// widget for Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text to display on the login screen to show the user
  // their verification status i.e press enter to submit, verifying or invalid code
  String loadingText = '(press enter to submit)';

  final DatabaseReference db = FirebaseDatabase().reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150, top: 50),
              child: Opacity(
                opacity: 0.15,
                child: Material(
                  color: Colors.transparent,
                  child: Hero(
                    tag: 'lock',
                    child: Lock(
                      lockPosition: 0,
                      otherColor: Theme.of(context).highlightColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: 650,
                  height: 110,
                  child: Card(
                    elevation: 5,
                    color: Theme.of(context).errorColor.withOpacity(0.45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: TextField(
                          onSubmitted: (text) {
                            verifyCode(text);
                          },
                          style: sizeHandler.currentTextTheme.headline1,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                bottom: 10, top: 25, right: 30, left: 30),
                          ),
                          cursorWidth: 3,
                          cursorRadius: const Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Enter your login code",
                  textAlign: TextAlign.center,
                  style: sizeHandler.currentTextTheme.headline1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  loadingText,
                  textAlign: TextAlign.center,
                  style: sizeHandler.currentTextTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// updates the loading text and
  /// verifies the code entered
  /// if verified, the user is logged in and the code saved
  Future verifyCode(String code) async {
    loadingText = 'verifying...';
    setState(() {});
    bool isValid = false;
    try {
      await db.child('devices').once().then((result) {
        isValid = result.value.containsKey(code);
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    if (isValid) {
      Get.find<Storage>().updateID(code);
    } else {
      setState(() {
        loadingText = 'Invalid code';
      });
    }
  }
}
