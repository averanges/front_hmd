import 'package:get/get.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:tuple/tuple.dart';

class InputPumpPlantingController extends GetxController {
  final FarmlandRepository farmlandRepository;
  final int farmlandId;

  InputPumpPlantingController({
    required this.farmlandRepository,
    required this.farmlandId,
  });

  final isLoading = false.obs;
  final enabledButton = false.obs;
  final isShowAddButton = true.obs;

  // 펌프 일정
  final pumpDates = Rx<List<Tuple2<DateTime, DateTime>?>>([null, null]);

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
          Get.offAllNamed(
            AppRoute.farmlandList,
            arguments: {
              'farmlandId': farmlandId,
            },
          );
          injectRepositories();
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

    var isValid = true;
    var lastTimestamp = 0;
    for (final range in pumpDates.value) {
      // final start = range?.item1;
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

    // 농지 펌프 일정 등록
    final result = await farmlandRepository.postFarmlandWatering(
      farmlandId,
      pumpDates.value
          .where((element) => element != null)
          .map((e) => e!)
          .toList(),
    );

    isLoading.value = false;

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.toNamed(
        AppRoute.farmingInfoDrainWaterPlanting,
        arguments: {
          'farmlandId': farmlandId,
        },
      );
    }
  }

  void onClickedAddSchedule() {
    if (pumpDates.value.length < 5) {
      pumpDates.value.add(null);
      pumpDates.refresh();
    } else {
      showErrorDialog('input_pump_error_maximum'.tr);
    }
  }

  void onSelectedDay(int index, DateTime? day) {
    // 펌프 일정 선택
    // pumpDates.value[index] = day;
    // pumpDates.refresh();
    //
    // _checkCondition();
  }

  void onSelectedRange(int index, Tuple2<DateTime, DateTime> range) {
    // 펌프 일정 선택
    pumpDates.value[index] = range;
    pumpDates.refresh();

    _checkCondition();
  }

  void _checkCondition() {
    // 조건 확인
    enabledButton.value = pumpDates.value.every((element) => element != null);
  }
}
