import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/farmland/home/progress/farmland_progress_controller.dart';

class FarmlandProgressPage extends GetView<FarmlandProgressController> {
  const FarmlandProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FarmlandProgressController>(
      init: FarmlandProgressController(
        repository: Get.find(),
        farmlandId: Get.arguments['farmlandId'],
      ),
      builder: (context) => Scaffold(
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
                _titleView(),
                _lineView(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 25.0),
                          Row(
                            children: [
                              Text(
                                'progress_overall'.tr,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          // 1, 2 단계
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: AppColors.progressStatusBorder,
                                      width: 1.0,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15.5),
                                      // Planting
                                      AppImages.plantingIcon,
                                      const SizedBox(height: 5.0),
                                      Text(
                                        'progress_planting'.tr,
                                        style: const TextStyle(
                                          color: AppColors.progressStatusText,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Container(
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: AppColors.progressStatusBorder,
                                      width: 1.0,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15.5),
                                      // Planting
                                      Obx(() => controller
                                          .status.value.firstAwdStatus),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        'progress_1st_awd'.tr,
                                        style: const TextStyle(
                                          color: AppColors.progressStatusText,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          // 3, 4 단계
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: AppColors.progressStatusBorder,
                                      width: 1.0,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15.5),
                                      // Planting
                                      Obx(() => controller
                                          .status.value.secondAwdStatus),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        'progress_2nd_awd'.tr,
                                        style: const TextStyle(
                                          color: AppColors.progressStatusText,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Container(
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: AppColors.progressStatusBorder,
                                      width: 1.0,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15.5),
                                      // Planting
                                      Obx(() => controller
                                          .status.value.harvestStatus),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        'progress_harvest'.tr,
                                        style: const TextStyle(
                                          color: AppColors.progressStatusText,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 45.0),
                          // 펌프 기록
                          Row(
                            children: [
                              Text(
                                'progress_record_pump'.tr,
                                style: const TextStyle(
                                  color: AppColors.textLabel1st,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                              const Spacer(),
                              Obx(
                                () => Text(
                                  '${controller.pumpCount.value}/4',
                                  style: const TextStyle(
                                    color: AppColors.progressStatusCount,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            width: Get.width - 50.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: AppColors.progressStatusBorder,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Obx(
                              () => Row(
                                children: [
                                  Container(
                                    width: (Get.width - 50.0) /
                                        4 *
                                        controller.pumpCount.value,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: AppColors.progressStatusComplete,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          // 펌프 기록
                          Row(
                            children: [
                              Text(
                                'progress_record_photo'.tr,
                                style: const TextStyle(
                                  color: AppColors.textLabel1st,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                              const Spacer(),
                              Obx(
                                () => Text(
                                  controller.status.value.awdPhotoCount,
                                  style: const TextStyle(
                                    color: AppColors.progressStatusCount,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 28.0,
                                    decoration: BoxDecoration(
                                      color: controller
                                              .status.value.isCheckedPhoto1st
                                          ? AppColors.progressStatusComplete
                                          : AppColors.progressStatusBorder,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: controller
                                            .status.value.isCheckedPhoto1st
                                        ? const Icon(
                                            Icons.check,
                                            color: AppColors.white,
                                            size: 14,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: Container(
                                    height: 28.0,
                                    decoration: BoxDecoration(
                                      color: controller
                                              .status.value.isCheckedPhoto2nd
                                          ? AppColors.progressStatusComplete
                                          : AppColors.progressStatusBorder,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: controller
                                            .status.value.isCheckedPhoto2nd
                                        ? const Icon(
                                            Icons.check,
                                            color: AppColors.white,
                                            size: 14,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

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
            TitleView(title: 'progress_title'.tr),
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
                'progress_finish_project'.tr,
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
