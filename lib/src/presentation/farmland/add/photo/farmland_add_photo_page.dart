import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/farmland/add/photo/farmland_add_photo_controller.dart';

class FarmlandAddPhotoPage extends GetView<FarmlandAddPhotoController> {
  const FarmlandAddPhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FarmlandAddPhotoController>(
      init: FarmlandAddPhotoController(),
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
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
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.045),
                        Obx(() => controller.photo.value == null
                            ? _addPhotoView()
                            : _infoView()),
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
            TitleView(title: 'farmland_add_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

  Widget _addPhotoView() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.takePicture();
          },
          child: Container(
            width: double.infinity,
            height: (Get.width - 50) * 0.55,
            decoration: BoxDecoration(
              color: AppColors.calendarDisabledText,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.add_circle,
                    size: 40.0,
                    color: AppColors.addPhotoIcon,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Center(
                      child: Text(
                        'take_picture'.tr,
                        style: const TextStyle(
                          color: AppColors.recordDiaryMemoTitle,
                          fontSize: AppDimens.font12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _infoView() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: (Get.width - 50) * 0.55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.memory(
                      controller.photo.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 59,
                    maxHeight: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC686868),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  margin: const EdgeInsets.only(top: 5, left: 7),
                  alignment: Alignment.center,
                  child: const Text(
                    '농지 이미지',
                    style: TextStyle(
                      fontSize: 8.0,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            _rowGPSInfo('latitude'.tr, controller.location?.latitude ?? 0.0),
            const SizedBox(height: 10.0),
            _rowGPSInfo('longitude'.tr, controller.location?.longitude ?? 0.0),
          ],
        ),
      );

  Widget _rowGPSInfo(String name, double data) => SizedBox(
        height: 33.0,
        child: Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                color: AppColors.textLabel1st,
                fontSize: AppDimens.font12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Container(
                height: 33.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: AppColors.textFieldBg,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  data.toStringAsFixed(7),
                  style: const TextStyle(
                    color: AppColors.textLabel1st,
                    fontSize: AppDimens.font14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
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
