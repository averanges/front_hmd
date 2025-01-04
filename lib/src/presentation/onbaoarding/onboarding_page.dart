import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/onbaoarding/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topView(),
            SizedBox(height: Get.height * 0.07),
            SmoothPageIndicator(
              controller: controller.pageController,
              count: 5,
              effect: const WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                type: WormType.normal,
                spacing: 12,
                activeDotColor: AppColors.activeDot,
                dotColor: AppColors.defaultDot,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: PageView(
                      controller: controller.pageController,
                      children: _buildPageView(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 20.0),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              controller.onClickedPrev();
                            },
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                          const Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              controller.onClickedNext();
                            },
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                          const SizedBox(width: 20.0),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                ],
              ),
            ),
            // _bottomView(),
          ],
        ),
      ),
    );
  }

  Widget _topView() => Container(
        color: AppColors.enabledButton,
        height: 44.0,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // 건너뛰기 버튼
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.onClickedSkip();
              },
              child: Container(
                width: 100.0,
                height: 44.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  'skip'.tr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppDimens.font13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // 다음 버튼
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.onClickedNext();
              },
              child: Container(
                width: 100.0,
                height: 44.0,
                alignment: Alignment.centerRight,
                child: Text(
                  'next'.tr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppDimens.font13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  // 숨김처리 (클라이언트 요청)
  // ignore: unused_element
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
            color: AppColors.bottomSheetBlackBg,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(0.0, -2.0),
                blurRadius: 7.2,
                blurStyle: BlurStyle.outer,
              )
            ]),
        child: _nextButton(),
      );

  Widget _nextButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onClickedShowTutorial();
        },
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.enabledButton,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'tutorial_video'.tr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.font16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  List<Widget> _buildPageView() {
    switch (Get.locale) {
      case const Locale('ko_KR'):
        return _tutorialPages('ko');
      case const Locale('en_US'):
        return _tutorialPages('en');
      case const Locale('vi_VN'):
        return _tutorialPages('vi');
      case const Locale('km_KH'):
        return _tutorialPages('kh');
      case const Locale('bn_BD'):
        return _tutorialPages('bd');
      default:
        return _tutorialPages('ko');
    }
  }

  List<Widget> _tutorialPages(String countryCode) {
    return [
      _buildTutorialImage(countryCode, 1),
      _buildTutorialImage(countryCode, 2),
      _buildTutorialImage(countryCode, 3),
      _buildTutorialImage(countryCode, 4),
      _buildTutorialImage(countryCode, 5),
    ];
  }

  Widget _buildTutorialImage(String countryCode, int orderingNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxHeight * 0.49,
              height: constraints.maxHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/tutorial/$countryCode/tutorial$orderingNumber.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
