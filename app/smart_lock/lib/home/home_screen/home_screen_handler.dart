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

  RxBool hasBreached = false
      .obs; // set to true if breached before, only false if user sets canOpen to true

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
    if (isOpen == true || hasBreached.value) {
      if (!canOpen.value) {
        // not allowed to be open
        state.value = LockState.breached;
        hasBreached.value = true;
        // update security todos
        todo1.value = todos1[1];
        todo3.value = todos3[1];
      } else {
        // allowed to be open
        state.value = LockState.unlocked;
        hasBreached.value = false;
        todo1.value = todos1[0]; // update security todos
      }
    } else if (deviceState == DeviceState.disabled) {
      state.value = LockState.disabled;
    } else {
      if (canOpen.value) {
        state.value = LockState.unlocked;
        todo3.value = todos3[1]; // update security todos

      } else {
        state.value = LockState.locked;
        todo3.value = todos3[0]; // update security todos

      }
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

  // security todos
  RxString todo1 = todos1[0].obs;

  static List<String> todos1 = [
    'No unresolved breaches',
    'Resolve breach',
  ];

  /// returns whether or not to show tick
  bool get todo1bool {
    return todos1[0] == todo1.value;
  }

  RxString todo2 = 'Passwords secure'.obs;
  RxString todo3 = todos3[0].obs;

  static List<String> todos3 = [
    'Device locked',
    'Device unlocked',
  ];

  /// returns whether or not to show tick
  bool get todo3bool {
    return todos3[0] == todo3.value;
  }
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
