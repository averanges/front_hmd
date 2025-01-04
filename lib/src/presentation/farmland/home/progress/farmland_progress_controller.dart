import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class FarmlandProgressController extends GetxController {
  final FarmlandRepository repository;
  final int farmlandId;

  FarmlandProgressController({
    required this.repository,
    required this.farmlandId,
  });

  final enabledButton = false.obs;
  final isLoading = false.obs;
  final status = AWDStatus.planting.obs;
  final pumpCount = 0.obs;

  @override
  void onReady() {
    super.onReady();

    _fetchAwdStatus();
  }

  void _fetchAwdStatus() async {
    final result = await repository.getAwdStatus(farmlandId);

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      final data = result.right;
      final awdStatus = data.item1;
      final pumpCount = data.item2;

      switch (awdStatus) {
        case AWDStatus.planting:
          enabledButton.value = false;
          break;
        case AWDStatus.pendingAwd1st:
          enabledButton.value = false;
          break;
        case AWDStatus.awd1st:
          enabledButton.value = false;
          break;
        case AWDStatus.pendingAwd2nd:
          enabledButton.value = false;
          break;
        case AWDStatus.awd2nd:
          enabledButton.value = false;
          break;
        case AWDStatus.harvest:
          enabledButton.value = true;
          break;
      }
      status.value = awdStatus;
      this.pumpCount.value = pumpCount;
    }
  }

  void onBackPressed() {
    Get.back();
  }

  void onClickedOkButton() {
    if (enabledButton.value == false) {
      showErrorDialog('progress_error_message'.tr);
      return;
    } else if (isLoading.value) {
      return;
    }

    Get.dialog(
      CommonDialog(
        message: 'progress_finish_project_popup_message'.tr,
        isShowInfoIcon: true,
        iconType: IconType.infoGray,
        dialogType: DialogType.white,
        rightButtonText: 'yes'.tr,
        onRightButtonClicked: () {
          _proceedFinishProject();
        },
        leftButtonText: 'no'.tr,
      ),
    );
  }

  void _proceedFinishProject() async {
    isLoading.value = true;

    final result = await repository.completeProject(farmlandId);

    isLoading.value = false;
    if (result.isLeft) {
      showErrorDialog(result.left.message);
      return;
    }

    Get.offAllNamed(
      AppRoute.farmlandList,
    );
    injectRepositories();
  }
}

enum AWDStatus {
  planting, // 모내기
  pendingAwd1st, // 1차 물빼기 심사
  awd1st, // 1차 물빼기
  pendingAwd2nd, // 2차 물빼기 심사
  awd2nd, // 2차 물빼기
  harvest; // 수확

  // from json
  static AWDStatus fromJson(String status) {
    switch (status.toUpperCase()) {
      case 'PLANTING':
        return AWDStatus.planting;
      case 'PENDING_AWD_1ST':
        return AWDStatus.pendingAwd1st;
      case 'AWD_1ST':
        return AWDStatus.awd1st;
      case 'PENDING_AWD_2ND':
        return AWDStatus.pendingAwd2nd;
      case 'AWD_2ND':
        return AWDStatus.awd2nd;
      case 'HARVEST':
        return AWDStatus.harvest;
      default:
        return AWDStatus.planting;
    }
  }

  Widget get firstAwdStatus => switch (this) {
        AWDStatus.pendingAwd1st => AppImages.awdStatusProceedIcon,
        AWDStatus.planting => AppImages.awdStatusPendingIcon,
        _ => AppImages.awdStatusCompletedIcon
      };

  Widget get secondAwdStatus => switch (this) {
        AWDStatus.awd2nd => AppImages.awdStatusCompletedIcon,
        AWDStatus.pendingAwd2nd => AppImages.awdStatusProceedIcon,
        AWDStatus.harvest => AppImages.awdStatusCompletedIcon,
        _ => AppImages.awdStatusPendingIcon
      };

  Widget get harvestStatus => switch (this) {
        AWDStatus.harvest => AppImages.harvestStatusCompletedIcon,
        _ => AppImages.harvestStatusPendingIcon
      };

  String get awdPhotoCount => switch (this) {
        AWDStatus.planting => '0/2',
        AWDStatus.pendingAwd1st => '1/2',
        AWDStatus.awd1st => '1/2',
        AWDStatus.pendingAwd2nd => '2/2',
        AWDStatus.awd2nd => '2/2',
        AWDStatus.harvest => '2/2',
      };

  bool get isCheckedPhoto1st => switch (this) {
        AWDStatus.planting => false,
        _ => true,
      };

  bool get isCheckedPhoto2nd => switch (this) {
        AWDStatus.planting => false,
        AWDStatus.pendingAwd1st => false,
        AWDStatus.awd1st => false,
        _ => true,
      };
}
