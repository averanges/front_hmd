import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/farmland/home/mypage/my_page_controller.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPageController>(
      init: MyPageController(
        authRepository: Get.find(),
        storageManager: Get.find(),
        signupRepository: Get.find(),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 60,
                    color: AppColors.myPageTopBg,
                  ),
                  _titleView(),
                ],
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        color: AppColors.myPageTopBg,
                      ),
                      Container(
                        height: 60,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 11),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 25,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.myPageShadow,
                            blurRadius: 9.2,
                            offset: Offset(6, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.userName.value,
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                'my_page_name_title'.tr,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          Text(
                            'my_page_hello'.tr,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _rowMenuView(MyPageMenu.awdChange),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.awdChangeHistory),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.pumpChange),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.pumpChangeHistory),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.faq),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.termsService),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.termsPrivacy),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.qna),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.awdEdu),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.language),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.tutorial),
                      const SizedBox(height: 18.0),
                      _rowNotificationOnOff(),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.appVersion),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.logout),
                      const SizedBox(height: 18.0),
                      _rowMenuView(MyPageMenu.withdraw),
                      const SizedBox(height: 18.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleView() => Container(
        height: 44.0,
        margin: const EdgeInsets.only(top: 44.0),
        color: AppColors.myPageTopBg,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(children: [
          AppImages.smallLogo,
          const Spacer(),
          // GestureDetector(
          //   onTap: () {
          //     controller.onClickedChangeRequestHistory();
          //   },
          //   child: SizedBox(
          //     width: 25,
          //     height: 25,
          //     child: AppImages.bellICon,
          //   ),
          // ),
        ]),
      );

  Widget _rowMenuView(MyPageMenu menu) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onClickedMenu(menu);
        },
        child: Row(
          children: [
            const SizedBox(width: 30.0),
            Text(
              menu.name,
              style: const TextStyle(
                color: AppColors.myPageMenuText,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            menu == MyPageMenu.appVersion
                ? Obx(()=>
                  Text(
                      controller.appVersion.value,
                      style: const TextStyle(
                        color: AppColors.myPageMenuText,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                )
                : AppImages.arrowRightIcon,
            const SizedBox(width: 30.0),
          ],
        ),
      );

  Widget _rowNotificationOnOff() {
    const menu = MyPageMenu.notification;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.onClickedMenu(menu);
      },
      child: Row(
        children: [
          const SizedBox(width: 30.0),
          Text(
            menu.name,
            style: const TextStyle(
              color: AppColors.myPageMenuText,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Obx(
            () => CupertinoSwitch(
              value: controller.isAlarmEnabled.value,
              activeColor: AppColors.mainBlue,
              trackColor: AppColors.recordSwitchTrack,
              thumbColor: AppColors.white,
              onChanged: (value) {
                controller.onClickedNotification(value);
              },
            ),
          ),
          const SizedBox(width: 30.0),
        ],
      ),
    );
  }
}

enum MyPageMenu {
  awdChange,
  awdChangeHistory,
  pumpChange,
  pumpChangeHistory,
  faq,
  termsService,
  termsPrivacy,
  qna,
  awdEdu,
  language,
  tutorial,
  notification,
  appVersion,
  logout,
  withdraw;

  String get name => switch (this) {
        MyPageMenu.awdChange => 'my_page_menu_awd_change'.tr,
        MyPageMenu.awdChangeHistory => 'my_page_menu_awd_change_history'.tr,
        MyPageMenu.pumpChange => 'my_page_menu_pump_change'.tr,
        MyPageMenu.pumpChangeHistory => 'my_page_menu_pump_change_history'.tr,
        MyPageMenu.faq => 'my_page_menu_faq'.tr,
        MyPageMenu.termsService => 'my_page_menu_terms_service'.tr,
        MyPageMenu.termsPrivacy => 'my_page_menu_terms_privacy'.tr,
        MyPageMenu.qna => 'my_page_menu_qna'.tr,
        MyPageMenu.awdEdu => 'my_page_menu_awd_edu'.tr,
        MyPageMenu.language => 'Language', //'my_page_menu_language'.tr,
        MyPageMenu.tutorial => 'my_page_menu_tutorial'.tr,
        MyPageMenu.notification => 'my_page_menu_notification'.tr,
        MyPageMenu.appVersion => 'my_page_menu_app_version'.tr,
        MyPageMenu.logout => 'my_page_menu_logout'.tr,
        MyPageMenu.withdraw => 'my_page_menu_withdraw'.tr,
      };
}
