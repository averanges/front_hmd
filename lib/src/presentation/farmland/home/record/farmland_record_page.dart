import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/farmland/home/farmland_home_controller.dart';
import 'package:haimdall/src/presentation/farmland/home/record/calendar/range/drain_water/calendar_range_item.dart';
import 'package:haimdall/src/presentation/farmland/home/record/farmland_record_controller.dart';
import 'package:haimdall/src/presentation/farmland/home/record/model/farmland_event.dart';
import 'package:intl/intl.dart';
import 'package:klc/klc.dart';
import 'package:table_calendar/table_calendar.dart';

class FarmlandRecordPage extends GetView<FarmlandRecordController> {
  const FarmlandRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FarmlandRecordController>(
      init: FarmlandRecordController(
        farmlandId: Get.find<FarmlandHomeController>().farmlandId,
        farmlandRepository: Get.find<FarmlandRepository>(),
        storageManager: Get.find<StorageManager>(),
      ),
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomMaterialIndicator(
            onRefresh: () async => controller.onRefresh(),
            backgroundColor: AppColors.white,
            indicatorBuilder: (context, controller) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircularProgressIndicator(
                  color: AppColors.mainBlue,
                  value: this.controller.refreshLoadingValue.value,
                      // ? null
                      // : min(controller.value, 1.0),
                ),
              );
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 타이틀
                  _titleView(),
                  // 유저 이름
                  _nameView(),
                  // 캘린더
                  _calendarView(),
                  const SizedBox(height: 16.0),
                  // 캘린더 색상 정보
                  _informationView(),
                  const SizedBox(height: 23.0),
                  // 기록 뷰
                  _recordView(),
                  // 일지 작성 뷰
                  _recordDiaryView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleView() => Container(
        height: 44.0,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(children: [
          AppImages.smallLogo,
          const Spacer(),
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: () {
          //     controller.onClickedChangeRequestHistory();
          //   },
          //   child: SizedBox(
          //     width: 25,
          //     height: 25,
          //     child: AppImages.bellICon,
          //   ),
          // ),
        ]),
      );

  Widget _nameView() => Container(
        height: 45.0,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        color: AppColors.mainBlue,
        child: Row(
          children: [
            Obx(
              () => Text(
                controller.userName.value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            // GestureDetector(
            //   behavior: HitTestBehavior.translucent,
            //   onTap: () {
            //     // 일정 변경 요청 화면 이동
            //     controller.onClickedChangeRequest();
            //   },
            //   child: SizedBox(
            //     width: 25,
            //     height: 25,
            //     child: AppImages.circlePlusWhiteIcon,
            //   ),
            // ),
          ],
        ),
      );

  Widget _calendarView() {
    final now = DateTime.now();
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 13.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C6C6C).withOpacity(0.08),
            blurRadius: 9.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            return TableCalendar(
              locale: Get.locale?.toString() ?? 'ko_KR',
              firstDay: DateTime.utc(now.year - 1, now.month, now.day),
              lastDay: DateTime.utc(now.year + 1, now.month, now.day),
              focusedDay: controller.focusedDay.value,
              availableGestures: AvailableGestures.horizontalSwipe,
              eventLoader: (day) {
                return controller.getEventsForDay(day);
              },
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: AppColors.black,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              calendarStyle: CalendarStyle(
                tablePadding: const EdgeInsets.all(0.0),
                outsideDaysVisible: true,
                outsideTextStyle: const TextStyle(
                  color: AppColors.calendarDisabledText,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
                // Today 표시 여부
                isTodayHighlighted: true,
                // Today 글자 조정
                todayTextStyle: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
                // Today 모양 조정
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border.all(
                    color: AppColors.mainBlue,
                    width: 1.0,
                  ),
                  shape: BoxShape.circle,
                ),
                // selectedDay 글자 조정
                selectedTextStyle: const TextStyle(
                  color: AppColors.white,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
                // selectedDay 모양 조정
                selectedDecoration: const BoxDecoration(
                  color: AppColors.mainBlue,
                  shape: BoxShape.circle,
                ),
                // weekend 글자 조정
                weekendTextStyle: const TextStyle(
                  color: AppColors.calendarDefaultDay,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
                defaultTextStyle: const TextStyle(
                  color: AppColors.calendarDefaultDay,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              selectedDayPredicate: (day) {
                return isSameDay(controller.selectedDay.value, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                controller.onSelectedDay(selectedDay, focusedDay);
              },
              calendarBuilders: CalendarBuilders(
                rangeHighlightBuilder: _rangeHighlightBuilder,
                headerTitleBuilder: _calendarHeaderBuilder,
                dowBuilder: _calendarDowBuilder,
                defaultBuilder: _calendarDefaultBuilder,
                markerBuilder: _calendarEventMarkerBuilder,
              ),
            );
          }),
          Container(
            height: 35.0,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 2.0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 14.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.toggleCheckedLunar();
                  },
                  child: Row(
                    children: [
                      Obx(
                        () => controller.isCheckedLunar.value
                            ? AppImages.checkedIcon
                            : AppImages.uncheckedIcon,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        'record_calendar_lunar'.tr,
                        style: const TextStyle(
                          color: AppColors.farmlandStatusTextColor,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationView() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Wrap(
          children: [
            _infoItem(FarmlandCalendarEventType.pumpOn),
            const SizedBox(width: 8.0),
            _infoItem(FarmlandCalendarEventType.pumpOff),
            const SizedBox(width: 8.0),
            _infoItem(FarmlandCalendarEventType.drainWaterStart),
            const SizedBox(width: 8.0),
            _infoItem(FarmlandCalendarEventType.drainWaterEnd),
          ],
        ),
      );

  Widget _infoItem(FarmlandCalendarEventType type) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: type.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3.0),
          Text(
            type.name,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
        ],
      );

  Widget _recordView() => Container(
        width: Get.width,
        color: AppColors.recordBg,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'record_title'.tr,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 24.0),
            _rowRecordView(_pumpOnOffView()),
            const SizedBox(height: 15.0),
            _rowRecordView(_drainWaterView()),
            const SizedBox(height: 15.0),
            _rowRecordView(_fertilizerView()),
            const SizedBox(height: 15.0),
            _rowRecordView(_pesticideView()),
            const SizedBox(height: 15.0),
            _harvestView(),
          ],
        ),
      );

  Widget _rowRecordView(Widget child) => Container(
        decoration: BoxDecoration(
          color: AppColors.recordRowBg,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.only(left: 14.0, right: 17.0),
        height: 55.0,
        child: child,
      );

  Widget _pumpOnOffView() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.recordEnabledIconBg),
            width: 25.0,
            height: 25.0,
            child: AppImages.pumpIcon,
          ),
          const SizedBox(width: 8.0),
          Text(
            'record_pump'.tr,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          Obx(
            () => CupertinoSwitch(
              value: controller.isPumpOn.value,
              activeColor: AppColors.mainBlue,
              trackColor: AppColors.recordSwitchTrack,
              thumbColor: AppColors.white,
              onChanged: (value) {
                controller.onClickedPumpOnOff(value);
              },
            ),
          ),
        ],
      );

  // 물빼기
  Widget _drainWaterView() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.recordEnabledIconBg),
            width: 25.0,
            height: 25.0,
            child: AppImages.waterIcon,
          ),
          const SizedBox(width: 8.0),
          Text(
            'record_drain_water'.tr,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              controller.onClickedDrainWater();
            },
            child: AppImages.plusIcon,
          ),
        ],
      );

  // 비료
  Widget _fertilizerView() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.recordEnabledIconBg),
            width: 25.0,
            height: 25.0,
            child: AppImages.fertilizerIcon,
          ),
          const SizedBox(width: 8.0),
          Text(
            'record_fertilizer'.tr,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              controller.onClickedFertilizer();
            },
            child: AppImages.plusIcon,
          ),
        ],
      );

  // 농약
  Widget _pesticideView() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.recordEnabledIconBg),
            width: 25.0,
            height: 25.0,
            child: AppImages.pesticideIcon,
          ),
          const SizedBox(width: 8.0),
          Text(
            'record_pesticide'.tr,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              controller.onClickedPesticide();
            },
            child: AppImages.plusIcon,
          ),
        ],
      );

  // 수확량 기록
  Widget _harvestView() => Obx(
        () => Container(
          decoration: BoxDecoration(
            color: controller.isAvailableRecordHarvest.value
                ? AppColors.recordRowBg
                : AppColors.recordRowDisabledBg,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.only(left: 14.0, right: 17.0),
          height: 55.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.isAvailableRecordHarvest.value
                      ? AppColors.recordEnabledIconBg
                      : AppColors.recordDisabledIconBg,
                ),
                width: 25.0,
                height: 25.0,
                child: controller.isAvailableRecordHarvest.value
                    ? AppImages.harvestEnabledIcon
                    : AppImages.harvestDisabledIcon,
              ),
              const SizedBox(width: 8.0),
              Text(
                'record_harvest'.tr,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  controller.onClickedHarvest();
                },
                child: AppImages.plusIcon,
              ),
            ],
          ),
        ),
      );

  Widget _recordDiaryView() => Container(
        color: AppColors.white,
        margin: const EdgeInsets.only(
          top: 30.0,
          left: 25.0,
          right: 25.0,
          bottom: 94.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'record_diary'.tr,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLabel1st,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'record_diary_option'.tr,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.recordDiaryMemoTitle,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              constraints: const BoxConstraints(
                minHeight: 152.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.recordDiaryInputBg,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: controller.diaryController,
                keyboardType: TextInputType.multiline,
                cursorColor: AppColors.mainBlue,
                minLines: 1,
                maxLines: 100,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textLabel1st,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'record_diary_hint'.tr,
                  hintStyle: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.recordDiaryHint,
                  ),
                ),
                onChanged: (value) {
                  controller.onChangedDiary(value);
                },
              ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  // 기록완료
                  controller.onClickedRecordDiary();
                },
                child: Container(
                  width: 151.0,
                  height: 33.0,
                  decoration: BoxDecoration(
                    color: AppColors.mainBlue,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Center(
                    child: Text(
                      'record_done'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppDimens.font12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  // Calendar Event Marker Builder
  Widget? _calendarEventMarkerBuilder(context, day, events) {
    // 이벤트 마커 표시
    return Container(
      margin: const EdgeInsets.only(top: 43.0),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          if (events[index] is FarmlandCalendarEventType) {
            final event = events[index] as FarmlandCalendarEventType;
            return Container(
              margin: const EdgeInsets.only(right: 2.0),
              width: 5.0,
              height: 5.0,
              decoration: BoxDecoration(
                color: event.color,
                shape: BoxShape.circle,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // Calendar Default Builder
  Widget? _calendarDefaultBuilder(context, day, focusedDay) {
    if (isSameDay(controller.selectedDay.value, day)) {
      return Container(
        margin: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(
          color: AppColors.mainBlue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            day.day.toString(),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      return Obx(
        () {
          final isShowLunarCalendar = controller.isCheckedLunar.value;
          var lunarDate = '';
          if (isShowLunarCalendar) {
            setSolarDate(day.year, day.month, day.day);
            final splitLunarIsoFormat = getLunarIsoFormat().split('-');
            lunarDate = splitLunarIsoFormat
                .sublist(1, splitLunarIsoFormat.length)
                .join('.');
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.day.toString(),
                  style: const TextStyle(
                    color: AppColors.textLabel1st,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isShowLunarCalendar)
                  Text(
                    '($lunarDate)',
                    style: const TextStyle(
                      color: AppColors.textLabel2nd,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }
  }

  // Calendar Dow Builder
  Widget? _calendarDowBuilder(context, day) {
    final dayString =
        DateFormat.EEEEE(Get.locale?.toString() ?? 'ko_KR').format(day);
    return Center(
      child: Text(
        dayString,
        style: TextStyle(
          color: day.weekday == DateTime.sunday
              ? AppColors.textRed
              : day.weekday == DateTime.saturday
                  ? AppColors.mainBlue
                  : AppColors.textLabel1st,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Calendar Header Builder
  Widget? _calendarHeaderBuilder(context, day) {
    return Row(
      children: [
        const SizedBox(width: 20.0),
        Text(
          DateFormat.yMMMM(Get.locale?.toString() ?? 'ko_KR').format(day),
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 40.0,
          height: 50.0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.onClickedPrevMonth();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.calendarArrow,
              size: 14.0,
            ),
          ),
        ),
        // const SizedBox(width: 20.0),
        SizedBox(
          width: 50.0,
          height: 50.0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.onClickedNextMonth();
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.calendarArrow,
              size: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  // Calendar Range Highlight Builder
  Widget? _rangeHighlightBuilder(
    BuildContext context,
    DateTime day,
    bool isWithinRange,
  ) {
    final data = controller.dateData.value;

    if (data == null) {
      return null;
    } else {
      final widget = data.wateringDateList.map<Widget?>((e) {
        // pump check
        final pumpOn = e.pumpOnDate;
        final pumpOff = e.pumpOffDate;
        if (pumpOn != null && pumpOff != null) {
          if (isSameDay(day, pumpOn)) {
            return CalendarRangeItem(
              isShowLunarDate: controller.isCheckedLunar,
              day: day,
              type: CalendarRangeType.start,
              color: CalendarRangeColor.pump,
            );
          } else if (isSameDay(day, pumpOff)) {
            return CalendarRangeItem(
              isShowLunarDate: controller.isCheckedLunar,
              day: day,
              type: CalendarRangeType.end,
              color: CalendarRangeColor.pump,
            );
          }
          if (day.isAfter(pumpOn) && day.isBefore(pumpOff)) {
            return CalendarRangeItem(
              isShowLunarDate: controller.isCheckedLunar,
              day: day,
              type: CalendarRangeType.middle,
              color: CalendarRangeColor.pump,
            );
          }
        }

        // drain check
        final drainStart = e.waterDrainStartDate;
        final drainEnd = e.waterDrainEndDate;
        if (drainStart != null && drainEnd != null) {
          if (isSameDay(day, drainStart)) {
            return CalendarRangeItem(
              isShowLunarDate: controller.isCheckedLunar,
              day: day,
              type: CalendarRangeType.start,
              color: CalendarRangeColor.drainWater,
            );
          } else if (isSameDay(day, drainEnd)) {
            return CalendarRangeItem(
              isShowLunarDate: controller.isCheckedLunar,
              day: day,
              type: CalendarRangeType.end,
              color: CalendarRangeColor.drainWater,
            );
          }
          if (day.isAfter(drainStart) && day.isBefore(drainEnd)) {
            return CalendarRangeItem(
              isShowLunarDate: controller.isCheckedLunar,
              day: day,
              type: CalendarRangeType.middle,
              color: CalendarRangeColor.drainWater,
            );
          }
        }

        return null;
      }).firstWhere((e) => e != null, orElse: () => null);

      return widget;
    }
  }
}
