import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/domain/model/farmland/recording/fertilizer/fertilizer.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';
import 'package:haimdall/src/presentation/farmland/home/record/fertilizer/fertilizer_record_controller.dart';

class FertilizerRecordPage extends GetView<FertilizerRecordController> {
  const FertilizerRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FertilizerRecordController>(
      init: FertilizerRecordController(
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
                            _inputTitleView('record_fertilizer_type'.tr),
                            const SizedBox(height: 8.0),
                            _pesticideDropdown(),
                            const SizedBox(height: 48.0),
                            _inputTitleView('record_fertilizer_usage'.tr),
                            const SizedBox(height: 8.0),
                            _pesticideUsageView(),
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
            TitleView(title: 'record_fertilizer_title'.tr),
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

  Widget _pesticideDropdown() => HaimdallDropdown<Fertilizer>(
        selectedValue: controller.selectedItem,
        items: Fertilizer.values.map(
          (data) {
            return HaimdallDropdownItem<Fertilizer>(
              value: data,
              label: data.toName(),
              onSelected: (value) {
                controller.onSelectItem(value);
              },
            );
          },
        ).toList(),
        hintText: 'record_fertilizer_input_hint'.tr,
      );

  Widget _pesticideUsageView() => SizedBox(
        width: Get.width - 50.0,
        height: 40.0,
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => TextField(
                  controller: controller.fertilizerUsageController,
                  cursorColor: AppColors.enabledButton,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  onChanged: (text) {
                    controller.onChangedUsage(text);
                  },
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: AppColors.textLabel1st,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: controller.isValidUsage.value
                        ? AppColors.textFieldValidBg
                        : AppColors.textFieldBg,
                    hintText: 'record_fertilizer_usage_input_hint'.tr,
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
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'kg',
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
