import 'package:flutter/material.dart';
import 'package:smart_lock/globals/widgets/lock.dart';

/// widget for Login
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lock(
          lockPosition: 0,
          otherColor: Theme.of(context).highlightColor,
        ),
      ),
    );
  }
}
