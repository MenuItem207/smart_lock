import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// widget for handling local data
class Storage extends GetxController {
  final box = GetStorage();

  /// initialises storage
  static Future init() async {
    final Storage storage = Get.put(Storage());
    await GetStorage.init();
    storage.id.value = storage.box.read('id');
    if (storage.id.value == null) {
      debugPrint('id is null');
    }
  }

  /// id of the device
  Rx<String?> id = Rx<String?>(null);

  /// updates the id of the device
  void updateID(String id) {
    this.id.value = id;
    box.write('id', id);
  }
}
