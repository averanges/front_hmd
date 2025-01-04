import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/domain/model/farmland/planting/planting_method.dart';
import 'package:haimdall/src/domain/model/farmland/planting/rice_cultivar.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';
import 'package:haimdall/src/presentation/farming/input_rice_planting/input_rice_planting_controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class InputRicePlantingPage extends GetView<InputRicePlantingController> {
  const InputRicePlantingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InputRicePlantingController>(
      init: InputRicePlantingController(
        farmlandRepository: Get.find<FarmlandRepository>(),
        farmlandId: Get.arguments['farmlandId'],
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (canPop, result) {
                if (!canPop) {
                  controller.onBackPressed();
                }
              },
              child: Column(
                children: [
                  _topLineView(),
                  _titleView(),
                  _lineView(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 36.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _inputTitleView('input_rice_planting_date'.tr),
                            const SizedBox(height: 8.0),
                            _plantingDateView(),
                            const SizedBox(height: 4.0),
                            Obx(() => controller.isShowCalendar.value
                                ? _calendarView()
                                : Container()),
                            const SizedBox(height: 26.0),
                            _inputTitleView('input_rice_planting_type'.tr),
                            const SizedBox(height: 8.0),
                            // 모내기 방식 선택
                            _plantingMethodDropdown(),
                            const SizedBox(height: 30.0),
                            _inputTitleView(
                                'input_rice_planting_rice_cultivar'.tr),
                            const SizedBox(height: 8.0),
                            // 벼 품종 선택
                            _riceCultivarDropdown(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _bottomView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topLineView() => Container(
        height: 5.0,
        color: AppColors.enabledButton,
      );

  Widget _titleView() => SizedBox(
        height: 44.0,
        child: Stack(
          children: [
            Row(
              children: [
                const SizedBox(width: 25.0),
                IconButton(
                  icon: AppImages.icBack,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    controller.onBackPressed();
                  },
                ),
                const Spacer(),
              ],
            ),
            TitleView(title: 'input_rice_planting_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

  Widget _inputTitleView(String title) => Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.textLabel1st,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _bottomView() => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 33.0,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(0.0, -2.0),
                blurRadius: 7.2,
                blurStyle: BlurStyle.outer,
              )
            ]),
        child: _okButton(),
      );

  Widget _okButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onClickedNextButton();
        },
        child: Obx(
          () => Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: controller.enabledButton.value
                  ? AppColors.enabledButton
                  : AppColors.disabledButton,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.snsLoginBorder,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'next'.tr,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: AppDimens.font16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _plantingMethodDropdown() => HaimdallDropdown<PlantingMethod>(
        selectedValue: controller.selectedPlantingMethod,
        items: PlantingMethod.values.map(
          (data) {
            return HaimdallDropdownItem<PlantingMethod>(
              value: data,
              label: data.toName(),
              onSelected: (value) {
                controller.onSelectedPlantingMethod(value);
              },
            );
          },
        ).toList(),
        hintText: 'input_rice_planting_type_hint'.tr,
      );

  Widget _riceCultivarDropdown() => HaimdallDropdown<RiceCultivar>(
        selectedValue: controller.selectedRiceCultivar,
        items: RiceCultivar.values.map(
          (data) {
            return HaimdallDropdownItem<RiceCultivar>(
              value: data,
              label: data.toName(),
              onSelected: (value) {
                controller.onSelectedRiceCultivar(value);
              },
            );
          },
        ).toList(),
        hintText: 'input_rice_planting_rice_cultivar_hint'.tr,
      );

  Widget _plantingDateView() => Obx(
        () {
          final selectedDay = controller.selectedDay.value;

          return Container(
            width: double.infinity,
            height: 40.0,
            decoration: BoxDecoration(
              color: selectedDay == null
                  ? AppColors.textFieldBg
                  : AppColors.textFieldValidBg,
              borderRadius: BorderRadius.circular(5.0),
              border: selectedDay == null
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
                  controller.onClickedSelectPlantingDate();
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
                        selectedDay == null
                            ? 'input_rice_planting_date_hint'.tr
                            : DateFormat('yyyy-MM-dd').format(selectedDay),
                        style: TextStyle(
                          fontSize: 13.0,
                          color: selectedDay == null
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

  Widget _calendarView() {
    final now = DateTime.now();

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
      child: TableCalendar(
        locale: Get.locale?.toString() ?? 'ko_KR',
        firstDay: DateTime.utc(now.year - 1, now.month, now.day),
        lastDay: DateTime.utc(now.year + 1, now.month, now.day),
        focusedDay: controller.focusedDay.value,
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
              fontWeight: FontWeight.w500),
          defaultTextStyle: const TextStyle(
              color: AppColors.calendarDefaultDay,
              fontSize: 11.0,
              fontWeight: FontWeight.w500),
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
          },
          dowBuilder: (context, day) {
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
          },
        ),
      ),
    );
  }
}
