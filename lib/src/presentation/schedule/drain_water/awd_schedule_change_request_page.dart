import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/schedule/drain_water/awd_schedule_change_request_controller.dart';
import 'package:haimdall/src/presentation/schedule/drain_water/item/awd_schedule_change_item.dart';

class AwdScheduleChangeRequestPage
    extends GetView<AwdScheduleChangeRequestController> {
  const AwdScheduleChangeRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AwdScheduleChangeRequestController>(
      init: AwdScheduleChangeRequestController(
        farmlandRepository: Get.find(),
        farmlandId: Get.arguments['farmlandId'],
      ),
      builder: (controller) => Scaffold(
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
                              itemCount: controller.inputList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 30.0),
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                return AwdScheduleChangeItem(
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
                          const SizedBox(height: 30.0),
                          _inputTitleView('schedule_change_request_reason'.tr),
                          const SizedBox(height: 26.0),
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
                              controller: controller.reasonController,
                              keyboardType: TextInputType.multiline,
                              cursorColor: AppColors.mainBlue,
                              minLines: 1,
                              maxLines: 100,
                              maxLength: 3000,
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
                                counterText: '',
                              ),
                              onChanged: (value) {
                                controller.onChangedReason(value);
                              },
                            ),
                          ),
                          const SizedBox(height: 24.0),
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
      ),
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
            TitleView(title: 'schedule_change_request_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

  Widget _inputTitleView(String title) => Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
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
          controller.onClickedOkButton();
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
