import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';

class SignupWaitingPage extends StatelessWidget {
  const SignupWaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.textFieldValidBg,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 65.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            'signup_waiting_desc1'.tr,
                            style: const TextStyle(
                              fontSize: 30.0,
                              color: AppColors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25.0),
                  ],
                ),
              ),
              const SizedBox(height: 2.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            'signup_waiting_desc2'.tr,
                            style: const TextStyle(
                              fontSize: 30.0,
                              color: AppColors.dialogRightButtonBg,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 68.0),
              AppImages.waitingImage,
              const Spacer(),
              _bottomView(),
            ],
          ),
        ));
  }

  Widget _bottomView() => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 33.0,
        ),
        decoration: const BoxDecoration(
            color: AppColors.white,
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
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.enabledButton,
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
      );
}
