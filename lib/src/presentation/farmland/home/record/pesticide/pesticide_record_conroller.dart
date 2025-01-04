import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/domain/model/farmland/recording/pesticide/pesticide.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';

class PesticideRecordController extends GetxController {
  final FarmlandRepository farmlandRepository;
  final int farmlandId;
  final DateTime targetDate;

  PesticideRecordController({
    required this.farmlandRepository,
    required this.farmlandId,
    required this.targetDate,
  });

  final isLoading = false.obs;
  final enabledButton = false.obs;
  final selectedItem = Rxn<Pesticide>();
  final usage = 0.0.obs;
  final pesticideUsageController = TextEditingController();
  final isValidUsage = false.obs;

  void onBackPressed() {
    // 뒤로가기
    if (selectedItem.value != null || usage.value > 0) {
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

  void onClickedOkButton() async {
    // 농약 기록
    if (!enabledButton.value) {
      showInputErrorDialog();
      return;
    } else if (isLoading.value) {
      return;
    }

    _showConfirmRecordPopup();
  }

  void onSelectItem(Pesticide? item) {
    selectedItem.value = item;
    _checkCondition();
  }

  void onChangedUsage(String value) {
    usage.value = (double.tryParse(value) ?? 0);
    isValidUsage.value = usage.value > 0;
    _checkCondition();
  }

  void _checkCondition() {
    enabledButton.value = selectedItem.value != null && usage.value > 0;
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
    if (enabledButton.value == false) {
      showInputErrorDialog();
      return;
    } else if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    final result = await farmlandRepository.postFarmlandRecord(
      farmlandId,
      targetDate,
      pesticideType: selectedItem.value!.toApiValue(),
      pesticideAmount: usage.value,
    );

    isLoading.value = false;

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    pesticideUsageController.dispose();
    super.onClose();
  }
}
