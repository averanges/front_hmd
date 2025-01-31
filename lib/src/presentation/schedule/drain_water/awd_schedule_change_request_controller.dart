import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:tuple/tuple.dart';

class AwdScheduleChangeRequestController extends GetxController {
  final FarmlandRepository farmlandRepository;
  final int farmlandId;

  AwdScheduleChangeRequestController({
    required this.farmlandRepository,
    required this.farmlandId,
  });

  final inputList = <Tuple2<DateTime, DateTime>?>[].obs;
  final reason = ''.obs;

  final isLoading = false.obs;
  final enabledButton = false.obs;
  final reasonController = TextEditingController();

  @override
  void onReady() {
    super.onReady();

    _fetchWateringCount();
  }

  void _fetchWateringCount() async {
    final result = await farmlandRepository.getWateringCount(farmlandId);

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      final wateringCount = result.right;

      inputList.value = List.generate(wateringCount, (_) => null);
    }
  }

  void onBackPressed() {
    // 뒤로가기
    if (inputList.firstWhereOrNull((e) => e != null) != null) {
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
    // 확인 버튼 클릭
    if (!enabledButton.value) {
      showInputErrorDialog();
      return;
    } else if (isLoading.value) {
      return;
    }

    var isValid = true;
    var lastTimestamp = 0;
    for (final range in inputList) {
      final end = range?.item2;
      if (lastTimestamp == 0) {
        lastTimestamp = end?.millisecondsSinceEpoch ?? 0;
      } else {
        if (lastTimestamp > (end?.millisecondsSinceEpoch ?? 0)) {
          isValid = false;
          break;
        }
      }
    }
    if (!isValid) {
      showErrorDialog('input_pump_error_date'.tr);
      return;
    }

    isLoading.value = true;

    final result = await farmlandRepository.changeAwdSchedule(
      farmlandId,
      inputList.where((element) => element != null).map((e) => e!).toList(),
      reason.value,
    );

    isLoading.value = false;

    FocusManager.instance.primaryFocus?.unfocus();

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.back();
    }
  }

  void onSelectedRange(int index, Tuple2<DateTime, DateTime> range) {
    // 물빼기 일정 선택
    inputList[index] = range;
    inputList.refresh();

    _checkCondition();
  }

  void onChangedReason(String value) {
    // 사유 입력
    reason.value = value;
    _checkCondition();
  }

  void _checkCondition() {
    // 조건 확인
    enabledButton.value =
        inputList.every((element) => element != null) && reason.isNotEmpty;
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
