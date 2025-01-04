import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/common/language/languages.dart';
import 'package:haimdall/src/presentation/localization/localization_controller.dart';

class LocalizationPage extends GetView<LocalizationController> {
  const LocalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _titleView(),
            _lineView(),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(height: 28),
                  // Korean
                  _languageItem(Languages.korean),
                  _drawLine(),
                  _languageItem(Languages.english),
                  _drawLine(),
                  _languageItem(Languages.vietnamese),
                  _drawLine(),
                  _languageItem(Languages.bangladeshi),
                  _drawLine(),
                  _languageItem(Languages.cambodian),
                  _drawLine(),
                ],
              ),
            ),
            const Spacer(),
            Container(
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
            ),
          ],
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
                    Get.back();
                  },
                ),
                const Spacer(),
              ],
            ),
            TitleView(title: 'select_language_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

  Widget _languageItem(Languages type) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        controller.onSelectedLanguage(Locale(type.locale)),
      },
      child: SizedBox(
        height: 55.0,
        child: Row(
          // mainAxisAlignment: Alignment.star,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 25.0),
            type.icons,
            const SizedBox(width: 7.0),
            Text(
              type.name,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
                color: AppColors.textLabel1st,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 25.0),
            Obx(() {
              return controller.locale.value == Locale(type.locale)
                  ? AppImages.icRadioChecked
                  : AppImages.icRadioUnchecked;
            }),
            const SizedBox(width: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _drawLine() {
    return Container(
      height: 1.0,
      color: AppColors.line,
    );
  }

  Widget _okButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onClickedUpdateLanguage();
        },
        child: Obx(
          () => Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: controller.locale.value == null
                    ? AppColors.disabledButton
                    : AppColors.enabledButton,
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
              )),
        ),
      );
}
