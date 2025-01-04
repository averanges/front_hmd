import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class FarmlandHomeController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;
  final farmlandId = Get.arguments['farmlandId'] ?? -1;

  void onItemTapped(int index) {
    if (index == 1) {
      // 진행현황 페이지는 탭에서 보여주지 않는다.
      Get.toNamed(
        AppRoute.farmlandProgress,
        arguments: {
          'farmlandId': farmlandId,
        },
      );
      return;
    }

    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
