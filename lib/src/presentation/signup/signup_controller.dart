import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/regex/regex.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final enabledButton = false.obs;

  final isNameValid = false.obs;
  final isPhoneValid = false.obs;
  final isEmailValid = false.obs;

  void onClickedNextButton() async {
    if (enabledButton.value == false) {
      Get.dialog(
        CommonDialog(
          message: 'input_error'.tr,
          isShowInfoIcon: true,
          iconType: IconType.infoGray,
          dialogType: DialogType.white,
          rightButtonText: 'ok'.tr,
        ),
      );
      return;
    }

    final result = await Get.find<SignupRepository>().signupUser(
      nameController.text,
      _makeNationalPhoneNumber(phoneController.text),
      emailController.text,
    );

    if (result.isLeft) {
      Get.dialog(
        CommonDialog(
          message: result.left.message,
          isShowInfoIcon: true,
          iconType: IconType.infoGray,
          dialogType: DialogType.white,
          rightButtonText: 'ok'.tr,
        ),
      );
    } else {
      Get.toNamed(AppRoute.signupSelectProject);
    }
  }

  String _makeNationalPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('010')) {
      switch (Get.locale) {
        case const Locale('ko_KR'):
          return '+82${phoneNumber.substring(1)}';
        // 미국
        case const Locale('en_US'):
          return '+1${phoneNumber.substring(1)}';
        // 베트남
        case const Locale('vi_VN'):
          return '+84${phoneNumber.substring(1)}';
        // 캄보디아
        case const Locale('km_KH'):
          return '+855${phoneNumber.substring(1)}';
        // 방글라데시
        case const Locale('bn_BD'):
          return '+880${phoneNumber.substring(1)}';
        default:
          return '+82${phoneNumber.substring(1)}';
      }
    }

    return phoneNumber;
  }

  void onBackPressed() {
    Get.dialog(
      CommonDialog(
        message: 'input_warning_back'.tr,
        isShowInfoIcon: true,
        iconType: IconType.infoGray,
        dialogType: DialogType.white,
        rightButtonText: 'yes'.tr,
        onRightButtonClicked: () {
          Get.back();
        },
        leftButtonText: 'no'.tr,
      ),
    );
  }

  void onChangedName(String text) {
    isNameValid.value = text.length >= 2;
    _checkEnabledButton();
  }

  void onChangedPhone(String text) {
    isPhoneValid.value = Regexes.isValidMobileNumber(text);
    _checkEnabledButton();
  }

  void onChangedEmail(String text) {
    isEmailValid.value = Regexes.isValidEmail(text);
    _checkEnabledButton();
  }

  void _checkEnabledButton() {
    enabledButton.value =
        isNameValid.value && isPhoneValid.value && isEmailValid.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
