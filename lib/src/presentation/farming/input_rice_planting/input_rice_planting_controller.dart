import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/domain/model/farmland/planting/planting_method.dart';
import 'package:haimdall/src/domain/model/farmland/planting/rice_cultivar.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class InputRicePlantingController extends GetxController {
  final FarmlandRepository farmlandRepository;
  final int farmlandId;

  InputRicePlantingController({
    required this.farmlandRepository,
    required this.farmlandId,
  });

  final isLoading = false.obs;
  final enabledButton = false.obs;
  final plantingMethodController = TextEditingController();
  final riceVarietiesController = TextEditingController();

  final selectedPlantingMethod = Rxn<PlantingMethod>();
  final selectedRiceCultivar = Rxn<RiceCultivar>();

  final isShowCalendar = false.obs;
  final focusedDay = DateTime.now().obs;
  final selectedDay = Rxn<DateTime>();

  void onBackPressed() {
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

  void onClickedNextButton() async {
    // 다음 버튼 클릭
    if (!enabledButton.value) {
      showInputErrorDialog();
      return;
    } else if (isLoading.value) {
      return;
    }

    final selectedDay = this.selectedDay.value;
    final selectedPlantingMethod = this.selectedPlantingMethod.value;
    final selectedRiceCultivar = this.selectedRiceCultivar.value;

    if (selectedDay == null ||
        selectedPlantingMethod == null ||
        selectedRiceCultivar == null) {
      return;
    }

    isLoading.value = true;

    final result = await farmlandRepository.patchFarmlandPlanting(
      farmlandId,
      selectedDay,
      selectedPlantingMethod.toApiValue(),
      selectedRiceCultivar.toApiValue(),
    );

    isLoading.value = false;

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.toNamed(
        AppRoute.farmingInfoPumpPlanting,
        arguments: {
          'farmlandId': farmlandId,
        },
      );
    }
  }

  void onClickedSelectPlantingDate() {
    // 모내기 일자 선택
    isShowCalendar.toggle();
  }

  void onClickedPrevMonth() {
    final current = focusedDay.value;
    focusedDay.value = DateTime(
      current.year,
      current.month - 1,
      current.day,
    );
  }

  void onClickedNextMonth() {
    final current = focusedDay.value;
    focusedDay.value = DateTime(
      current.year,
      current.month + 1,
      current.day,
    );
  }

  void onSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    // 모내기 일자 선택
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    isShowCalendar.toggle();
    _checkCondition();
  }

  void onSelectedPlantingMethod(PlantingMethod? method) {
    // 모내기 방식 선택 (2가지)
    selectedPlantingMethod.value = method;
    _checkCondition();
  }

  void onSelectedRiceCultivar(RiceCultivar? data) {
    // 벼 품종 선택 (임시)
    selectedRiceCultivar.value = data;
    _checkCondition();
  }

  void _checkCondition() {
    // 조건 확인
    enabledButton.value = selectedPlantingMethod.value != null &&
        selectedRiceCultivar.value != null &&
        selectedDay.value != null;
  }

  @override
  void onClose() {
    plantingMethodController.dispose();
    riceVarietiesController.dispose();
    super.onClose();
  }
}
