import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

final SizeHandler sizeHandler = Get.put(SizeHandler());

/// this class handlers the widget layout based on screen size
class SizeHandler {
  /// there are two widget layouts, wide and narrow
  RxBool isWide = false.obs;

  /// the current screen constraints
  late BoxConstraints constraints;

  /// updates the current screen constraints and isWide
  void updateSizeHandler(BoxConstraints constraints) {
    this.constraints = constraints;
    isWide.value = constraints.maxWidth >= constraints.maxHeight;
  }
}
