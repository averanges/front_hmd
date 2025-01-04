import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/farmland/add/farmland_add_controller.dart';

class FarmlandAddPage extends GetView<FarmlandAddController> {
  const FarmlandAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (canPop, result) {
            if (!canPop) {
              controller.onBackFarmlandAdd();
            }
          },
          child: Column(
            children: [
              _titleView(),
              _lineView(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.045),
                      _inputView(),
                      SizedBox(height: Get.height * 0.045),
                    ],
                  ),
                ),
              ),
              _bottomView(),
            ],
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
                    controller.onBackFarmlandAdd();
                  },
                ),
                const Spacer(),
              ],
            ),
            TitleView(title: 'farmland_add_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

  Widget _inputView() => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 23.0),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'farmland_owner_name'.tr,
                      style: const TextStyle(
                        color: AppColors.textLabel1st,
                        fontSize: AppDimens.font13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(width: 4.0),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            'farmland_owner_name_desc'.tr,
                            style: const TextStyle(
                              color: AppColors.textRed,
                              fontSize: AppDimens.font12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // 농지 주인 이름
            _inputOwnerNameView(),
            const SizedBox(height: 26.0),
            Row(
              children: [
                Text(
                  'farmland_area'.tr,
                  style: const TextStyle(
                    color: AppColors.textLabel1st,
                    fontSize: AppDimens.font13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8.0),
            // 농지 면적
            _inputFarmAreaSizeView(),
            const SizedBox(height: 26.0),
          ],
        ),
      );

  Widget _inputOwnerNameView() => Obx(
        () => TextField(
          controller: controller.nameController,
          cursorColor: AppColors.enabledButton,
          keyboardType: TextInputType.name,
          onChanged: (text) {
            controller.onChangedFarmlandOwnerName(text);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: controller.isNameValid.value
                ? AppColors.textFieldValidBg
                : AppColors.textFieldBg,
            hintText: 'farmland_owner_name_input_hint'.tr,
            hintStyle: const TextStyle(
              fontSize: 13.0,
              color: AppColors.textLabel2nd,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.textFieldBg,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.textFieldBg,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.focusedTextFieldStroke,
                width: 1,
              ),
            ),
          ),
        ),
      );

  Widget _inputFarmAreaSizeView() => Stack(
        children: [
          Obx(
            () => TextField(
              controller: controller.areaSizeController,
              cursorColor: AppColors.enabledButton,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              onChanged: (text) {
                controller.onChangedFarmlandAreaSize(text);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: controller.isAreaSizeValid.value
                    ? AppColors.textFieldValidBg
                    : AppColors.textFieldBg,
                hintText: 'farmland_area_input_hint'.tr,
                hintStyle: const TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textLabel2nd,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.textFieldBg,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.textFieldBg,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.focusedTextFieldStroke,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'farmland_area_unit'.tr,
                  style: const TextStyle(
                    color: AppColors.textLabel3rd,
                    fontSize: AppDimens.font13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
              ],
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
          controller.onClickedAddInfo();
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
}
