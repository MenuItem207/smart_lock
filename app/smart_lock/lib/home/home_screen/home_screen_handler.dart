import 'dart:convert';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:smart_lock/globals/controllers/storage.dart';

/// handles the states of the home screen
class HomeScreenHandler extends GetxController {
  final Storage storage = Get.find<Storage>();
  late final DatabaseReference database = FirebaseDatabase.instance
      .reference()
      .child("devices")
      .child(storage.id.value!);

  /// the current state of the home screen
  Rx<LockState> state = Rx<LockState>(LockState.locked);

  RxBool canOpen = true.obs;
  bool isOpen = true;
  DeviceState deviceState = DeviceState.setup;
  List passwords = [];
  List images = [];

  bool hasBreached =
      false; // set to true if breached before, only false if user sets canOpen to true

  /// syncs the local state with the server
  void updateData(newData) {
    canOpen.value = json.decode(newData['can_open']);
    isOpen = json.decode(newData['is_open']);
    passwords = json.decode(newData['passwords']);
    deviceState = DeviceState.values[newData['state'] - 1];
    images = json.decode(newData['images']);
    updateLockState();
  }

  /// updates the lock state based on the current state of the device
  void updateLockState() {
    if (isOpen == true || hasBreached) {
      if (!canOpen.value) {
        // not allowed to be open
        state.value = LockState.breached;
        hasBreached = true;
      } else {
        // allowed to be open
        state.value = LockState.unlocked;
        hasBreached = false;
      }
    } else if (deviceState == DeviceState.disabled) {
      state.value = LockState.disabled;
    } else {
      state.value = (canOpen.value) ? LockState.unlocked : LockState.locked;
    }
  }

  /// user quick action
  void quickAction() {
    switch (state.value) {
      case LockState.locked:
        database.update({'can_open': "true"});
        break;
      case LockState.unlocked:
        database.update({'can_open': "false"});
        break;
      case LockState.breached:
        // TODO: implement
        break;
      case LockState.disabled:
        database.update({'state': 2});
        break;
    }
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
    LockState.breached: 'Breach detected',
    LockState.disabled: 'Your device is disabled',
  };
  Map quickActionTexts = {
    LockState.locked: 'unlock device',
    LockState.unlocked: 'lock device',
    LockState.breached: 'open security centre',
    LockState.disabled: 'Enable device',
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
  disabled,
}
