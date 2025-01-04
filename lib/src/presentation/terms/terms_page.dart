import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/terms/terms_controller.dart';
import 'package:haimdall/src/presentation/terms/terms_description_widget.dart';

class TermsPage extends GetView<TermsController> {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 5.0, color: AppColors.enabledButton),
            SizedBox(
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
                          if (GetPlatform.isAndroid) {
                            SystemNavigator.pop();
                          } else {
                            exit(0);
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                  TitleView(title: 'terms_page_title'.tr),
                ],
              ),
            ),
            Container(height: 1.0, color: AppColors.line),
            AppImages.termsContents,
            const SizedBox(height: 28),

            const TermsDescriptionWidget(),

            const Spacer(),

            // 약관
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.onClickedTermsPrivacy();
              },
              child: _checkTerms('terms_check_required'.tr, isRequired: true),
            ),

            // 약관
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.onClickedTermsService();
              },
              child: _checkTerms('terms_check_service'.tr),
            ),

            const SizedBox(height: 39.0),

            // Button
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
              child: _nextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onClickedNextButton();
        },
        child: Obx(
          () => Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: controller.enableButton.value
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
              )),
        ),
      );

  Widget _checkTerms(String text, {bool isRequired = false}) => SizedBox(
        height: 54.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 15.0),
            Obx(
              () => isRequired
                  ? controller.isCheckedTermsPrivacy.value
                      ? AppImages.icCircleChecked
                      : AppImages.icCircleUnchecked
                  : controller.isCheckedTermsService.value
                      ? AppImages.icCircleChecked
                      : AppImages.icCircleUnchecked,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.textLabel1st,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                isRequired
                    ? controller.onClickedMoveTermsPrivacy()
                    : controller.onClickedMoveTermsService();
              },
              child: AppImages.icArrow,
            ),
            const SizedBox(width: 10.0),
          ],
        ),
      );
}
