import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class OnboardingController extends GetxController {
  final SignupRepository repository;
  final StorageManager storageManager;

  final pageController = PageController(initialPage: 0);
  final nextToBack = Get.arguments?['nextToBack'] ?? false;

  OnboardingController({
    required this.repository,
    required this.storageManager,
  });

  void onClickedNext() {
    if (pageController.page == 4) {
      onClickedSkip();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onClickedPrev() {
    if (pageController.page == 0) {
      // Do Nothing
    } else {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onClickedSkip() async {
    if (nextToBack) {
      Get.back();
    } else {
      final result = await repository.completeTutorial();

      if (result.isLeft) {
        showErrorDialog(result.left.message);
        return;
      }

      Get.toNamed(
        AppRoute.awd,
        arguments: {'isTutorial': true},
      );
    }
  }

  void onClickedShowTutorial() async {
    // Do Nothing
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
