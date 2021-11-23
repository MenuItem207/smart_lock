import 'dart:convert';

import 'package:get/get.dart';

/// handles the states of the home screen
class HomeScreenHandler extends GetxController {
  /// the current state of the home screen
  Rx<LockState> state = Rx<LockState>(LockState.locked);

  bool canOpen = true;
  bool isOpen = true;
  DeviceState deviceState = DeviceState.setup;
  List passwords = [];
  List images = [];

  /// syncs the local state with the server
  void updateData(newData) {
    print('updating data');
    canOpen = json.decode(newData['can_open']);
    isOpen = json.decode(newData['is_open']);
    passwords = json.decode(newData['passwords']);
    deviceState = DeviceState.values[newData['state']];
    images = json.decode(newData['images']);
  }

  String get deviceStatement {
    /// returns the statement about the device
    return deviceStatements[state.value];
  }

  String get quickActionText {
    /// returns text to display on the button underneath the device statement
    return quickActionTexts[state.value];
  }

  Map deviceStatements = {
    LockState.locked: 'Your device is secure',
    LockState.unlocked: 'Your device is unlocked',
    LockState.breached: 'Breach detected'
  };
  Map quickActionTexts = {
    LockState.locked: 'unlock device',
    LockState.unlocked: 'lock device',
    LockState.breached: 'open security centre'
  };
}

enum DeviceState {
  setup,
  idle,
  password,
  disabled,
}

enum LockState {
  locked,
  unlocked,
  breached,
}
