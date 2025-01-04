import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/domain/model/signup/project/project_info.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class SignupProjectController extends GetxController {
  final enabledButton = false.obs;
  final projectList = <ProjectInfo>[].obs;
  final selectedProject = Rxn<ProjectInfo>();
  final dropdownController = TextEditingController();

  @override
  void onReady() {
    super.onReady();

    _fetchProjectList();
  }

  void _fetchProjectList() async {
    final result = await Get.find<SignupRepository>().getProjectList();

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      projectList.value = result.right;
    }
  }

  void onSelectedProject(ProjectInfo? project) {
    selectedProject.value = project;
    enabledButton.value = selectedProject.value != null;
  }

  void onBackPressed() {
    Get.dialog(
      CommonDialog(
        message: 'input_warning_back'.tr,
        isShowInfoIcon: true,
        iconType: IconType.infoGray,
        dialogType: DialogType.white,
        rightButtonText: 'yes'.tr,
        onRightButtonClicked: () {
          Get.back();
        },
        leftButtonText: 'no'.tr,
      ),
    );
  }

  void onClickedNextButton() async {
    if (enabledButton.value == false) {
      return;
    }

    final result = await Get.find<SignupRepository>()
        .selectProject(selectedProject.value!.projectId);

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.toNamed(AppRoute.signupWaiting);
    }
  }

  @override
  void onClose() {
    dropdownController.dispose();
    super.onClose();
  }
}
