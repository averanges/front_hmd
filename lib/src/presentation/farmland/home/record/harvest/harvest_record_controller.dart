import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';

class HarvestRecordController extends GetxController {
  final FarmlandRepository farmlandRepository;
  final int farmlandId;
  final DateTime targetDate;

  HarvestRecordController({
    required this.farmlandRepository,
    required this.farmlandId,
    required this.targetDate,
  });

  final isLoading = false.obs;
  final enabledButton = false.obs;
  final harvestAmount = 0.0.obs;
  final harvestAmountController = TextEditingController();

  void onBackPressed() {
    // 뒤로가기
    if (harvestAmount.value > 0) {
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
    } else {
      Get.back();
    }
  }

  void onClickedOkButton() {
    // 농약 기록
    if (!enabledButton.value) {
      showInputErrorDialog();
      return;
    } else if (isLoading.value) {
      return;
    }

    _showConfirmRecordPopup();
  }

  void _showConfirmRecordPopup() {
    Get.dialog(
      CommonDialog(
        message: 'record_confirm_message'.tr,
        isShowInfoIcon: true,
        iconType: IconType.infoGray,
        dialogType: DialogType.white,
        rightButtonText: 'ok'.tr,
        onRightButtonClicked: () {
          _proceedRecord();
        },
        leftButtonText: 'cancel'.tr,
      ),
    );
  }

  void _proceedRecord() async {
    // 수확 기록
    isLoading.value = true;

    final result = await farmlandRepository.postFarmlandRecord(
      farmlandId,
      targetDate,
      harvestAmount: harvestAmount.value,
    );

    isLoading.value = false;

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.back();
    }
  }

  void onChangedHarvestAmount(String value) {
    harvestAmount.value = (double.tryParse(value) ?? 0);
    _checkCondition();
  }

  void _checkCondition() {
    enabledButton.value = harvestAmount.value > 0;
  }

  @override
  void onClose() {
    harvestAmountController.dispose();
    super.onClose();
  }
}
