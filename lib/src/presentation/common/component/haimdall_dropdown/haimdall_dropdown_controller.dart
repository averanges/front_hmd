import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HaimdallDropdownController<T> extends GetxController {
  final OverlayPortalController tooltipController = OverlayPortalController();
  final isShowingMenu = false.obs;

  final link = LayerLink();

  void onTap() {
    tooltipController.toggle();
    isShowingMenu.value = tooltipController.isShowing;
  }
}
