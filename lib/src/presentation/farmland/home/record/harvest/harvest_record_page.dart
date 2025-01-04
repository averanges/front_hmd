import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/farmland/home/record/harvest/harvest_record_controller.dart';

class HarvestRecordPage extends GetView<HarvestRecordController> {
  const HarvestRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HarvestRecordController>(
        init: HarvestRecordController(
          farmlandRepository: Get.find<FarmlandRepository>(),
          farmlandId: Get.arguments['farmlandId'],
          targetDate: Get.arguments['targetDate'],
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
                    _titleView(),
                    _lineView(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            children: [
                              _inputTitleView('harvest'.tr),
                              const SizedBox(height: 8.0),
                              _harvestAmountInputView(),
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
        });
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
            TitleView(title: 'record_harvest_title'.tr),
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
                'ok'.tr,
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

  Widget _inputTitleView(String title) => Row(
        children: [
          const SizedBox(width: 2.0),
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

  Widget _harvestAmountInputView() => SizedBox(
        width: Get.width - 50.0,
        height: 40.0,
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => TextField(
                  controller: controller.harvestAmountController,
                  cursorColor: AppColors.enabledButton,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  onChanged: (text) {
                    controller.onChangedHarvestAmount(text);
                  },
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: AppColors.textLabel1st,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: controller.enabledButton.value
                        ? AppColors.textFieldValidBg
                        : AppColors.textFieldBg,
                    hintText: 'record_harvest_input_hint'.tr,
                    hintStyle: const TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textLabel2nd,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 11.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: AppColors.textFieldBg,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: AppColors.textFieldBg,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: AppColors.focusedTextFieldStroke,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                't',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppDimens.font17,
                ),
              ),
            )
          ],
        ),
      );
}
