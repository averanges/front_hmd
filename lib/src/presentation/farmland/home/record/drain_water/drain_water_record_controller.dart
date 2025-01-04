import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/logger/logger.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class DrainWaterRecordController extends GetxController {
  final int farmlandId;
  final int wateringId;
  final FarmlandRepository repository;

  DrainWaterRecordController({
    required this.farmlandId,
    required this.wateringId,
    required this.repository,
  });

  final enabledButton = false.obs;
  final isLoading = false.obs;
  final photo = Rxn<Uint8List>();
  final location = Rxn<LocationData>();
  final recordTime = DateTime.now().obs;

  final picker = ImagePicker();

  void onBackPressed() {
    // 뒤로가기
    if (photo.value != null) {
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
    } else {
      Get.back();
    }
  }

  void onClickedOkButton() async {
    if (enabledButton.value == false) {
      showInputErrorDialog();
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    final latitude = location.value?.latitude ?? 0.0;
    final longitude = location.value?.longitude ?? 0.0;

    final result = await repository.patchFarmlandWatering(
      wateringId,
      farmlandId,
      double.parse(latitude.toStringAsFixed(7)),
      double.parse(longitude.toStringAsFixed(7)),
      DateTime.now(),
      photo.value!,
    );

    isLoading.value = false;

    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      Get.back(result: true);
    }
  }

  void takePicture() {
    Get.bottomSheet(
      Container(
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 17.0),
            InkWell(
              onTap: () {
                Get.back();
                _takePicture();
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF3E3E3E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'take_picture2'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF767676),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _takePicture() async {
    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          showErrorPermissionDialog();
          return;
        }
      }

      this.location.value = await location.getLocation();

      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720.0,
      );

      if (pickedFile == null) {
        return;
      }
      Log.i('[Photo] Path ${pickedFile.path}');
      photo.value = await pickedFile.readAsBytes();
      recordTime.value = DateTime.now();
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied' || e.code == 'camera_access_denied') {
        showErrorPermissionDialog();
      }
    }

    _checkCondition();
  }

  void _checkCondition() {
    enabledButton.value = photo.value != null;
  }
}
