import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/farming/input_pump_planting/input_pump_planting_controller.dart';
import 'package:haimdall/src/presentation/farming/input_pump_planting/item/pump_schedule_item.dart';

class InputPumpPlantingPage extends GetView<InputPumpPlantingController> {
  const InputPumpPlantingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InputPumpPlantingController>(
      init: InputPumpPlantingController(
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
                            Obx(
                              () => ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: controller.pumpDates.value.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 30.0),
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return PumpScheduleItem(
                                    key: ValueKey(index),
                                    index: index,
                                    // onSelectedDay: (selectedDay) {
                                    //   controller.onSelectedDay(
                                    //     index,
                                    //     selectedDay,
                                    //   );
                                    // },
                                    onSelectedRange: (selectedRange) {
                                      controller.onSelectedRange(
                                        index,
                                        selectedRange,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 26.0),
                            // Plus Button
                            Obx(
                              () {
                                if (controller.isShowAddButton.value) {
                                  return SizedBox(
                                    height: 60.0,
                                    child: Material(
                                      color: AppColors.dropdownBorder,
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        onTap: () {
                                          // 펌프 일정 추가
                                          controller.onClickedAddSchedule();
                                        },
                                        child: Center(
                                          child: AppImages.addPumpPlantingIcon,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
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
            TitleView(title: 'input_pump_planting_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

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
}
