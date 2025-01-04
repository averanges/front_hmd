import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/farming/input_drain_water_planting/item/drain_water_schedule_item_controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

class AwdScheduleChangeItem extends StatelessWidget {
  final int index;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRange;

  const AwdScheduleChangeItem({
    super.key,
    required this.index,
    required this.onSelectedRange,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        tag: 'awd_schedule_change_item_$index',
        init: ScheduleChangeItemController(),
        builder: (controller) {
          return Column(
            children: [
              _inputTitleView('input_drain_water_planting_index'.tr, index),
              const SizedBox(height: 8.0),
              _plantingDateView(
                controller.drainWaterPlantingDate,
                () => controller.onTapDrainWaterPlanting(),
              ),
              Obx(() {
                return controller.isShowCalendar.value
                    ? _calendarView(
                        controller,
                        controller.drainWaterDate,
                        controller.drainWaterFocusedDay,
                        (data) {
                          onSelectedRange(data);
                        },
                      )
                    : Container();
              }),
            ],
          );
        });
  }

  Widget _inputTitleView(String title, int index) => Row(
        children: [
          Text(
            title.replaceAll('{count}', (index + 1).toString()),
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.textLabel1st,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _plantingDateView(
    Rx<String> drainWaterPlantingDate,
    VoidCallback onTap,
  ) =>
      Obx(
        () {
          final period = drainWaterPlantingDate.value;

          return Container(
            width: double.infinity,
            height: 40.0,
            decoration: BoxDecoration(
              color: period.isEmpty
                  ? AppColors.textFieldBg
                  : AppColors.textFieldValidBg,
              borderRadius: BorderRadius.circular(5.0),
              border: period.isEmpty
                  ? null
                  : Border.all(
                      color: AppColors.focusedTextFieldStroke,
                      width: 1.0,
                    ),
            ),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(5.0),
                onTap: () {
                  // calendar on/off
                  onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13.0,
                  ),
                  child: Row(
                    children: [
                      AppImages.calendarIcon,
                      const SizedBox(width: 11.0),
                      Text(
                        period.isEmpty
                            ? 'input_drain_water_planting_select_hint'.tr
                            : period,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: period.isEmpty
                              ? AppColors.textLabel2nd
                              : AppColors.textLabel1st,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      AppImages.angleDownIcon,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

  Widget _calendarView(
    ScheduleChangeItemController controller,
    Rxn<DateTime> selectedDay,
    Rx<DateTime> focusedDay,
    // ValueChanged<DateTime> onSelectedDay,
    ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRange,
  ) {
    var now = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0.0, 5.0),
            blurRadius: 14.0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Obx(
        () => TableCalendar(
          locale: Get.locale?.toString() ?? 'ko_KR',
          firstDay: DateTime.utc(now.year - 1, now.month, now.day),
          lastDay: DateTime.utc(now.year + 1, now.month, now.day),
          focusedDay: focusedDay.value,
          availableGestures: AvailableGestures.horizontalSwipe,
          calendarStyle: CalendarStyle(
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
            // outsideDay 노출 여부
            outsideDaysVisible: true,
            // outsideDay 글자 조정
            outsideTextStyle: const TextStyle(
              color: AppColors.calendarDisabledText,
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
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
            return isSameDay(selectedDay.value, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            // onSelectedDay(selectedDay);
          },
          rangeStartDay: controller.drainWaterStart.value,
          rangeEndDay: controller.drainWaterEnd.value,
          onRangeSelected: (start, end, focusedDay) {
            if (start != null && end != null) {
              onSelectedRange(Tuple2(start, end));
            }
            controller.onRangeSelected(start, end, focusedDay);
          },
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, day) {
              return Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text(
                    DateFormat.yMMMM(Get.locale?.toString() ?? 'ko_KR')
                        .format(day),
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
                        final current = focusedDay.value;
                        focusedDay.value = DateTime(
                          current.year,
                          current.month - 1,
                          current.day,
                        );
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
                        final current = focusedDay.value;
                        focusedDay.value = DateTime(
                          current.year,
                          current.month + 1,
                          current.day,
                        );
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
            },
            dowBuilder: (context, day) {
              final dayString =
                  DateFormat.EEEEE(Get.locale?.toString() ?? 'ko_KR')
                      .format(day);
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
            },
          ),
        ),
      ),
    );
  }
}
