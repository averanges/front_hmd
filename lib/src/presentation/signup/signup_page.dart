import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/signup/signup_controller.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
              Container(height: 5.0, color: AppColors.enabledButton),
              _titleView(),
              _lineView(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),
                      _inputName(),
                      const SizedBox(height: 27),
                      _inputPhone(),
                      const SizedBox(height: 27),
                      _inputEmail(),
                      const SizedBox(height: 100),
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
                    controller.onBackPressed();
                  },
                ),
                const Spacer(),
              ],
            ),
            TitleView(title: 'signup_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

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
        child: _nextButton(),
      );

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
                'next'.tr,
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

  Widget _inputName() => Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 27),
              Text(
                'signup_input_name'.tr,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLabel1st,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Obx(
              () => TextField(
                controller: controller.nameController,
                cursorColor: AppColors.enabledButton,
                keyboardType: TextInputType.name,
                onChanged: (text) {
                  controller.onChangedName(text);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: controller.isNameValid.value
                      ? AppColors.textFieldValidBg
                      : AppColors.textFieldBg,
                  hintText: 'signup_input_name_hint'.tr,
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
          ),
        ],
      );

  Widget _inputPhone() => Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 27),
              Text(
                'signup_input_phone'.tr,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLabel1st,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Obx(
              () => TextField(
                controller: controller.phoneController,
                cursorColor: AppColors.enabledButton,
                keyboardType: TextInputType.phone,
                maxLength: 14,
                onChanged: (text) {
                  controller.onChangedPhone(text);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: controller.isPhoneValid.value
                      ? AppColors.textFieldValidBg
                      : AppColors.textFieldBg,
                  hintText: 'signup_input_phone_hint'.tr,
                  hintStyle: const TextStyle(
                    fontSize: 13.0,
                    color: AppColors.textLabel2nd,
                  ),
                  counterText: '',
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
          ),
        ],
      );

  Widget _inputEmail() => Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 27),
              Text(
                'signup_input_email'.tr,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLabel1st,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Obx(
              () => TextField(
                controller: controller.emailController,
                cursorColor: AppColors.enabledButton,
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  controller.onChangedEmail(text);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: controller.isEmailValid.value
                      ? AppColors.textFieldValidBg
                      : AppColors.textFieldBg,
                  hintText: 'signup_input_email_hint'.tr,
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
          ),
        ],
      );
}
