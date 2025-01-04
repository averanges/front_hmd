import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/splash/splash_controller.dart';

class PermissionSheet extends StatelessWidget {
  const PermissionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (result, result2) {
        _closeApp();
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 43),
                    child: const Text(
                      '서비스 이용을 위해\n접근 권한 허용이 필요합니다.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // 권한 동의 하지 않음 => 앱 종료
                          _closeApp();
                        },
                        child: AppImages.iconClose,
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 43),
                color: const Color(0xFFFAFAFA),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: Row(
                        children: [
                          AppImages.iconCircleCamera,
                          const SizedBox(width: 11),
                          const Text(
                            '카메라 권한',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: Row(
                        children: [
                          AppImages.iconCirclePhoto,
                          const SizedBox(width: 11),
                          const Text(
                            '사진 권한',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: Row(
                        children: [
                          AppImages.iconCircleLocation,
                          const SizedBox(width: 11),
                          const Text(
                            '위치 권한',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // make rounded blue button radius 10

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  controller.requestPermissions();
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E80FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '계속하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 33),
            ],
          ),
        ),
      ),
    );
  }

  void _closeApp() {
    if (GetPlatform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }
}
