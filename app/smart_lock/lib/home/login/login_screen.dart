import 'package:flutter/material.dart';
import 'package:smart_lock/globals/widgets/lock.dart';

/// widget for Login
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                child: Lock(
                  lockPosition: 0,
                  otherColor: Theme.of(context).highlightColor,
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
                    color: Theme.of(context).errorColor.withOpacity(0.45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      onChanged: (text) {},
                      onSubmitted: (text) {},
                      style: Theme.of(context).textTheme.headline1,
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
                        hintText: "",
                      ),
                      cursorWidth: 3,
                      cursorRadius: const Radius.circular(3),
                    ),
                  ),
                ),
                Text(
                  "Enter your login code",
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "(press enter to submit)",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
