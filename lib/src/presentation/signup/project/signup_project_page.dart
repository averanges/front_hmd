import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/domain/model/signup/project/project_info.dart';
import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';
import 'package:haimdall/src/presentation/signup/project/signup_project_controller.dart';

class SignupProjectPage extends GetView<SignupProjectController> {
  const SignupProjectPage({super.key});

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26.0,
                      vertical: 36.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'signup_project_desc'.tr,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: AppColors.textLabel1st,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'signup_project_desc_point'.tr,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: AppColors.textRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Obx(
                          () => _projectDropdown(),
                        ),
                      ],
                    ),
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
            TitleView(title: 'signup_project_title'.tr),
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
            width: Get.width - 50.0,
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

  Widget _projectDropdown() => HaimdallDropdown<ProjectInfo>(
        selectedValue: controller.selectedProject,
        items: controller.projectList.map(
          (data) {
            return HaimdallDropdownItem<ProjectInfo>(
              value: data,
              label: data.toName(),
              onSelected: (value) {
                controller.onSelectedProject(value);
              },
            );
          },
        ).toList(),
        hintText: 'signup_project_select_hint'.tr,
      );
}
