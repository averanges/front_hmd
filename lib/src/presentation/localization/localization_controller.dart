import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';

class LocalizationController extends GetxController {
  final StorageManager storageManager;

  LocalizationController({
    required this.storageManager,
  });

  final locale = Rxn<Locale>();

  void onSelectedLanguage(Locale? locale) {
    this.locale.value = locale;
  }

  void onClickedUpdateLanguage() {
    // 언어 변경
    final locale = this.locale.value;
    if (locale == null) {
      // 팝업 표시
      Get.dialog(
        CommonDialog(
          message: 'select_language_error_message'.tr,
          isShowInfoIcon: true,
          iconType: IconType.infoWhite,
          dialogType: DialogType.black,
          rightButtonText: 'ok'.tr,
        ),
      );
      return;
    }

    // 선택 언어 저장
    storageManager.setValue(
      key: StorageManager.locale,
      value: locale.languageCode,
    );

    Get.updateLocale(locale);
    Get.back();
  }
}
