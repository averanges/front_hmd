import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/farmland/home/farmland_home_controller.dart';
import 'package:haimdall/src/presentation/farmland/home/mypage/my_page.dart';

import 'record/farmland_record_page.dart';

class FarmlandHomePage extends GetView<FarmlandHomeController> {
  const FarmlandHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const FarmlandRecordPage(),
            Container(),
            const MyPage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          currentIndex: controller.currentIndex.value,
          selectedItemColor: AppColors.tabSelected,
          unselectedItemColor: AppColors.tabUnselected,
          iconSize: 20.0,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          onTap: controller.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: AppImages.tabHomeIcon,
              activeIcon: AppImages.tabHomeActiveIcon,
              label: 'tab_home'.tr,
            ),
            BottomNavigationBarItem(
              icon: AppImages.tabProgressIcon,
              activeIcon: AppImages.tabProgressActiveIcon,
              label: 'tab_progress'.tr,
            ),
            BottomNavigationBarItem(
              icon: AppImages.tabMyPageIcon,
              activeIcon: AppImages.tabMyPageActiveIcon,
              label: 'tab_mypage'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
