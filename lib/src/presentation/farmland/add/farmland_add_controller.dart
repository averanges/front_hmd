import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';

class FarmlandAddController extends GetxController {
  final enabledButton = false.obs;

  // 농지 추가
  void onBackFarmlandAdd() {
    // 뒤로가기
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

  final isNameValid = false.obs;
  final nameController = TextEditingController();

  void onChangedFarmlandOwnerName(String value) {
    isNameValid.value = value.length >= 2;
    _checkCondition();
  }

  final isAreaSizeValid = false.obs;
  final areaSizeController = TextEditingController();

  void onChangedFarmlandAreaSize(String value) {
    isAreaSizeValid.value = value.isNotEmpty;
    _checkCondition();
  }

  void onClickedAddInfo() async {
    if (isNameValid.value == false || isAreaSizeValid.value == false) {
      _showRequiredInfoDialog();
      return;
    }

    final result = await Get.find<FarmlandRepository>().addFarmlandInfo(
      nameController.text,
      double.parse(areaSizeController.text),
    );

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.back(result: true);
    }
  }

  void _showRequiredInfoDialog() {
    Get.dialog(
      CommonDialog(
        message: 'input_error'.tr,
        isShowInfoIcon: true,
        iconType: IconType.infoGray,
        dialogType: DialogType.white,
        rightButtonText: 'ok'.tr,
      ),
    );
  }

  void _checkCondition() {
    enabledButton.value = isNameValid.value && isAreaSizeValid.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    areaSizeController.dispose();
    super.onClose();
  }
}
