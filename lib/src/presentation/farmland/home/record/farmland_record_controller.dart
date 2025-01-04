import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/domain/model/farmland/calendar/farmland_date_data.dart';
import 'package:haimdall/src/domain/model/farmland/recording/farmland_record_data.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/farmland/home/progress/farmland_progress_controller.dart';
import 'package:haimdall/src/presentation/farmland/home/record/model/farmland_event.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:table_calendar/table_calendar.dart';

class FarmlandRecordController extends GetxController {
  final int farmlandId;
  final FarmlandRepository farmlandRepository;
  final StorageManager storageManager;

  FarmlandRecordController({
    required this.farmlandId,
    required this.farmlandRepository,
    required this.storageManager,
  });

  final refreshLoadingValue = 0.0.obs;
  final isCheckedLunar = false.obs;
  final isPumpOn = false.obs;
  final focusedDay = DateTime.now().obs;
  final selectedDay = Rxn<DateTime>(DateTime.now());
  final dateData = Rxn<FarmlandDateData>();
  final eventData = <DateTime, List<FarmlandCalendarEventType>>{}.obs;
  final farmlandRecordAvailableData = Rxn<FarmlandRecordData>();
  final isAvailableRecordHarvest = false.obs;
  final userName = ''.obs;
  final diaryText = ''.obs;
  final diaryController = TextEditingController();
  final awdStatus = Rxn<AWDStatus>();
  final pumpCount = Rxn<int>();

  @override
  void onReady() {
    super.onReady();

    userName.value = storageManager.userName;

    _fetchFarmlandDateData();
  }

  void onRefresh() async {
    await _fetchFarmlandDateData(showLoading: true);
    final targetDate = selectedDay.value;
    if (targetDate != null) {
      _fetchFarmlandRecordData(targetDate, showLoading: true);
    }
  }

  Future _fetchFarmlandDateData({bool showLoading = false}) async {
    if (showLoading) {
      refreshLoadingValue.value = 1.0;
    }
    final result =
        await Get.find<FarmlandRepository>().getFarmlandDateData(farmlandId);

    if (showLoading) {
      refreshLoadingValue.value = 0.0;
    }

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      final data = result.right;
      if (data.plantingDate == null ||
          data.wateringDateList.isEmpty ||
          data.wateringDateList
              .every((element) => element.waterDrainStartDate == null)) {
        // 농사 정보 입력 팝업 표시 (뒤로가기 및 닫힘 없음)
        Get.dialog(
          CommonDialog(
            message: 'record_input_data'.tr,
            isShowInfoIcon: true,
            iconType: IconType.infoGray,
            dialogType: DialogType.white,
            rightButtonText: 'input'.tr,
            onRightButtonClicked: () {
              if (data.plantingDate == null) {
                Get.toNamed(
                  AppRoute.farmingInfoRicePlanting,
                  arguments: {
                    'farmlandId': farmlandId,
                  },
                )?.then((value) {
                  _fetchFarmlandDateData();
                });
              } else {
                if (data.wateringDateList.isEmpty) {
                  Get.toNamed(
                    AppRoute.farmingInfoPumpPlanting,
                    arguments: {
                      'farmlandId': farmlandId,
                    },
                  )?.then((value) {
                    _fetchFarmlandDateData();
                  });
                } else {
                  Get.toNamed(
                    AppRoute.farmingInfoDrainWaterPlanting,
                    arguments: {
                      'farmlandId': farmlandId,
                    },
                  )?.then((value) {
                    _fetchFarmlandDateData();
                  });
                }
              }
            },
            canPop: false,
          ),
          barrierDismissible: false,
        );
      } else {
        dateData.value = data;
        var mapData = <DateTime, List<FarmlandCalendarEventType>>{};

        for (var element in data.wateringDateList) {
          var pumpOnDate = mapData[element.pumpOnDate!] ?? [];
          pumpOnDate.add(FarmlandCalendarEventType.pumpOn);
          mapData[element.pumpOnDate!] = pumpOnDate;

          var pumpOffDate = mapData[element.pumpOffDate!] ?? [];
          pumpOffDate.add(FarmlandCalendarEventType.pumpOff);
          mapData[element.pumpOffDate!] = pumpOffDate;

          var waterDrainStartDate = mapData[element.waterDrainStartDate!] ?? [];
          waterDrainStartDate.add(FarmlandCalendarEventType.drainWaterStart);
          mapData[element.waterDrainStartDate!] = waterDrainStartDate;

          var waterDrainEndDate = mapData[element.waterDrainEndDate!] ?? [];
          waterDrainEndDate.add(FarmlandCalendarEventType.drainWaterEnd);
          mapData[element.waterDrainEndDate!] = waterDrainEndDate;
        }

        eventData.value = mapData;
        focusedDay.refresh();

        _fetchFarmlandRecordData(DateTime.now());
      }
    }
  }

  void onClickedChangeRequest() {
    // 일정 변경 요청 화면 이동
    Get.toNamed(
      AppRoute.awdScheduleChangeRequest,
      arguments: {
        'farmlandId': farmlandId,
      },
    )?.then((_) => {
          _fetchFarmlandDateData(),
        });
  }

  void onClickedChangeRequestHistory() {
    // 일정 변경 요청 내역 화면 이동
    Get.toNamed(
      AppRoute.awdChangeRequestHistory,
      arguments: {
        'farmlandId': farmlandId,
      },
    )?.then((_) => {
          _fetchFarmlandDateData(),
        });
  }

  void toggleCheckedLunar() {
    isCheckedLunar.toggle();
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

  List<FarmlandCalendarEventType> getEventsForDay(DateTime day) {
    final events = LinkedHashMap(
      equals: isSameDay,
    )..addAll(eventData);

    return events[day] ?? [];
  }

  void onSelectedDay(DateTime selectedDate, DateTime focusedDate) async {
    selectedDay.value = selectedDate;
    focusedDay.value = focusedDate;

    _fetchFarmlandRecordData(selectedDate);
  }

  void _fetchFarmlandRecordData(DateTime targetDate,
      {bool showLoading = false}) async {
    if (showLoading) {
      refreshLoadingValue.value = 1.0;
    }
    // 날짜별 농사 기록 데이터 조회 (등록 여부 조회)
    final wateringId = farmlandRepository.findWateringId(targetDate);

    final result = await farmlandRepository.getFarmlandRecordData(
      farmlandId,
      wateringId,
      targetDate,
    );

    if (result.isLeft) {
      showErrorDialog(result.left.message);
      if (showLoading) {
        refreshLoadingValue.value = 0.0;
      }
      return;
    } else {
      final data = result.right;
      farmlandRecordAvailableData.value = data;
      isPumpOn.value = data.pumpOnRecord && !data.pumpOffRecord;
      // diary
      diaryText.value = data.diary;
      if (data.diary.isEmpty) {
        diaryController.clear();
      } else {
        diaryController.text = data.diary;
      }

      // 수확량 버튼은 진행 현황의 AWD_2ND 상태를 확인
      final awdStatusResult = await farmlandRepository.getAwdStatus(farmlandId);

      if (awdStatusResult.isLeft) {
        showErrorDialog(awdStatusResult.left.message);
        return;
      } else {
        // 2차 물빼기 날 이후만 가능
        final awd2ndDate =
            dateData.value?.wateringDateList[1].waterDrainEndDate;

        awdStatus.value = awdStatusResult.right.item1;
        pumpCount.value = awdStatusResult.right.item2;

        if (awd2ndDate == null) {
          isAvailableRecordHarvest.value = false;
        } else {
          isAvailableRecordHarvest.value =
              awdStatusResult.right.item1 == AWDStatus.awd2nd &&
                  (isSameDay(awd2ndDate, targetDate) ||
                      targetDate.isAfter(awd2ndDate));
        }
      }
    }
    if (showLoading) {
      refreshLoadingValue.value = 0.0;
    }
  }

  void onClickedPumpOnOff(bool value) {
    final targetDate = selectedDay.value;
    final today = DateTime.now();

    if (targetDate == null) {
      showErrorSelectDateDialog();
      return;
    } else if (!isSameDay(targetDate, today)) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    final pumpDate = isPumpOn.value
        ? farmlandRepository.findPumpOffDate(targetDate)
        : farmlandRepository.findPumpOnDate(targetDate);

    final data = farmlandRecordAvailableData.value;

    if (data == null ||
        (isPumpOn.value ? data.pumpOffRecord : data.pumpOnRecord) ||
        !isSameDay(pumpDate, targetDate)) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    final wateringId = farmlandRepository.findWateringId(targetDate);

    if (wateringId != null) {
      Get.dialog(
        CommonDialog(
          message: isPumpOn.value
              ? 'record_pump_off_message'.tr
              : 'record_pump_on_message'.tr,
          isShowInfoIcon: true,
          iconType: IconType.infoRed,
          dialogType: DialogType.white,
          rightButtonText: 'yes'.tr,
          onRightButtonClicked: () async {
            final result = await farmlandRepository.changePumpStatus(
              farmlandId,
              wateringId,
              !isPumpOn.value,
            );

            if (result.isLeft) {
              showErrorDialog(result.left.message);
            } else {
              isPumpOn.toggle();

              _fetchFarmlandRecordData(targetDate);
            }
          },
          leftButtonText: 'no'.tr,
        ),
      );
    }
  }

  void onClickedPesticide() {
    // 농약 기록 화면 이동
    final recordAvailableData = farmlandRecordAvailableData.value;

    _moveScreen(
      AppRoute.farmlandRecordPesticide,
      isAvailableRecord: recordAvailableData?.pesticide != true,
    );
  }

  void onClickedHarvest() {
    // 수확량 기록 화면 이동
    final isAvailableRecord = isAvailableRecordHarvest.value;

    final targetDate = selectedDay.value;

    if (targetDate == null) {
      showErrorSelectDateDialog();
      return;
    } else if (!isAvailableRecord) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    Get.toNamed(
      AppRoute.farmlandRecordHarvest,
      arguments: {
        'farmlandId': farmlandId,
        'targetDate': selectedDay.value,
      },
    )?.then((_) {
      _fetchFarmlandRecordData(targetDate);
    });
  }

  void onClickedFertilizer() {
    // 비료 기록 화면 이동
    final recordAvailableData = farmlandRecordAvailableData.value;
    _moveScreen(
      AppRoute.farmlandRecordFertilizer,
      isAvailableRecord: recordAvailableData?.fertilizer != true,
    );
  }

  void onClickedDrainWater() {
    // 물빼기 사진 인증 화면 이동
    final targetDate = selectedDay.value;

    if (targetDate == null) {
      showErrorSelectDateDialog();
      return;
    }

    final wateringId = farmlandRepository.findWateringId(
      targetDate,
      hasPump: false,
    );

    if (wateringId == null) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    final index = dateData.value!.wateringDateList
        .indexWhere((element) => element.wateringId == wateringId);
    final awdStatus = this.awdStatus.value;
    final pumpCount = this.pumpCount.value ?? 0;

    if (index == -1) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    final startDate =
        dateData.value!.wateringDateList[index].waterDrainStartDate;
    final endDate = dateData.value!.wateringDateList[index].waterDrainEndDate;

    final data = farmlandRecordAvailableData.value;
    if (data == null || data.watering == true) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    final now = DateTime.now();
    final isValid = (now.isAfter(startDate!) && now.isBefore(endDate!) ||
            isSameDay(now, startDate) ||
            isSameDay(now, endDate)) &&
        isSameDay(now, targetDate);

    if (index == 0 &&
        awdStatus == AWDStatus.planting &&
        pumpCount >= 2 &&
        isValid) {
      // 1차 일정 가능
    } else if (index == 1 && awdStatus == AWDStatus.awd1st && pumpCount >= 4 && isValid) {
      // 2차 일정 가능
    } else if (awdStatus == AWDStatus.awd2nd && pumpCount >= 4 && isValid) {
      // 3차 이상 일정 가능
    } else {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    Get.toNamed(
      AppRoute.farmlandRecordDrainWater,
      arguments: {
        'farmlandId': farmlandId,
        'wateringId': wateringId,
        'targetDate': targetDate,
      },
    )?.then((_) {
      _fetchFarmlandRecordData(targetDate);
    });
  }

  void _moveScreen(
    String routeName, {
    bool isAvailableRecord = true,
    int? wateringId,
  }) {
    if (isAvailableRecord == false) {
      showCannotModifiedDialog();
      return;
    }

    final targetDate = selectedDay.value;
    final today = DateTime.now();

    if (targetDate == null) {
      showErrorSelectDateDialog();
      return;
    } else if (targetDate.isAfter(today)) {
      showErrorDialog('cannot_modified'.tr);
      return;
    }

    Get.toNamed(
      routeName,
      arguments: {
        'farmlandId': farmlandId,
        'wateringId': wateringId,
        'targetDate': selectedDay.value,
      },
    )?.then((_) {
      _fetchFarmlandRecordData(targetDate);
    });
  }

  void onChangedDiary(String text) {
    // 하루 메모 (일지 작성)
    diaryText.value = text;
  }

  void onClickedRecordDiary() {
    // 하루 메모 (일지 등록)
    final targetDate = selectedDay.value;

    if (targetDate == null) {
      showErrorSelectDateDialog();
      return;
    }

    final text = diaryText.value;

    if (text.isEmpty) {
      showErrorDialog('record_diary_empty'.tr);
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    Get.dialog(
      CommonDialog(
        message: 'record_diary_confirm_message'.tr,
        isShowInfoIcon: true,
        iconType: IconType.infoGray,
        dialogType: DialogType.white,
        rightButtonText: 'yes'.tr,
        onRightButtonClicked: () async {
          final result = await farmlandRepository.postFarmlandRecord(
            farmlandId,
            targetDate,
            diary: text,
          );

          if (result.isLeft) {
            showErrorDialog(result.left.message);
            return;
          }
        },
        leftButtonText: 'no'.tr,
      ),
    );
  }

  @override
  void onClose() {
    diaryController.dispose();
    super.onClose();
  }
}
