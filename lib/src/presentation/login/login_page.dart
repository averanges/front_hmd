import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/login/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Column(
        children: [
          const Spacer(),
          // Logo
          AppImages.logo2,
          const SizedBox(height: 10),
          // Description
          // _description(),
          const SizedBox(height: 111),
          // Select Language Button
          _selectLanguageButton(),
          const Spacer(),
          // Login Description From SNS
          _loginDescSnsWidget(),
          const SizedBox(height: 30),
          // Google Login Button
          _googleLoginButton(),
          const SizedBox(height: 15),
          // Apple Login Button
          if (Platform.isIOS) _appleLoginButton(),
          const SizedBox(height: 88.0),
        ],
      ),
    );
  }

  // Widget _description() {
  //   return Text(
  //     'login_desc'.tr,
  //     textAlign: TextAlign.center,
  //     style: const TextStyle(
  //       color: Colors.black,
  //       fontSize: AppDimens.font12,
  //       fontWeight: FontWeight.w500,
  //     ),
  //   );
  // }

  Widget _selectLanguageButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 국가/언어 선택
        controller.onClickedSelectLanguage();
      },
      child: Container(
        width: Get.width / 1.607,
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: AppColors.loginButtonBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Language',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.font16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginDescSnsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 35.0),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.line,
          ),
        ),
        SizedBox(width: Get.width * 0.0333),
        Text(
          'login_desc_sns'.tr,
          style: const TextStyle(
            color: AppColors.snsLoginSubText,
            fontSize: AppDimens.font13,
          ),
        ),
        SizedBox(width: Get.width * 0.0333),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.line,
          ),
        ),
        const SizedBox(width: 35.0),
      ],
    );
  }

  Widget _googleLoginButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.onClickedGoogleLogin();
      },
      child: Container(
        width: double.infinity,
        height: 43,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.snsLoginBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImages.google,
            const SizedBox(width: 16),
            const Text(
              'Continue with Google',
              style: TextStyle(
                color: AppColors.snsLoginText,
                fontSize: AppDimens.font14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appleLoginButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        // Apple 소셜 로그인
        controller.onClickedAppleLogin();
      },
      child: Container(
        width: double.infinity,
        height: 43,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.snsLoginBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImages.apple,
            const SizedBox(width: 16),
            const Text(
              'Continue with Apple',
              style: TextStyle(
                color: AppColors.snsLoginText,
                fontSize: AppDimens.font14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
