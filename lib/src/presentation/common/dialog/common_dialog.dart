import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';

class CommonDialog extends AlertDialog {
  final bool isShowInfoIcon;
  final IconType iconType;
  final String titleText;
  final String message;
  final DialogType dialogType;
  final String rightButtonText;
  final VoidCallback? onRightButtonClicked;
  final String leftButtonText;
  final VoidCallback? onLeftButtonClicked;
  final bool canPop;

  const CommonDialog({
    super.key,
    required this.message,
    this.titleText = '',
    this.isShowInfoIcon = false,
    this.iconType = IconType.infoGray,
    this.dialogType = DialogType.white,
    this.rightButtonText = '',
    this.onRightButtonClicked,
    this.leftButtonText = '',
    this.onLeftButtonClicked,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30.0),
            if (isShowInfoIcon) _infoIcon(iconType),
            if (titleText.isNotEmpty) _title(titleText),
            _message(message),
          ],
        ),
        backgroundColor: dialogType == DialogType.black
            ? AppColors.blackDialogBg
            : AppColors.white,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          if (leftButtonText.isNotEmpty)
            _button(
              leftButtonText,
              onLeftButtonClicked,
              AppColors.dialogLeftButtonBg,
              isCenter: rightButtonText.isEmpty,
            ),
          if (rightButtonText.isNotEmpty)
            _button(
              rightButtonText,
              onRightButtonClicked,
              AppColors.dialogRightButtonBg,
              isCenter: leftButtonText.isEmpty,
            ),
        ],
      ),
    );
  }

  Widget _infoIcon(IconType iconType) {
    switch (iconType) {
      case IconType.infoGray:
        return AppImages.icInfoGray;
      case IconType.infoWhite:
        return AppImages.icInfoWhite;
      case IconType.infoRed:
        return AppImages.icInfoRed;
    }
  }

  Widget _title(String title) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        title,
        style: TextStyle(
          color: dialogType == DialogType.black
              ? AppColors.white
              : AppColors.dialogTextBlack,
          fontSize: AppDimens.font19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _message(String message) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        message,
        style: TextStyle(
          color: dialogType == DialogType.black
              ? AppColors.white
              : AppColors.dialogTextBlack,
          fontSize: AppDimens.font12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _button(
    String text,
    VoidCallback? onClicked,
    Color backgroundColor, {
    bool isCenter = false,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();
        onClicked?.call();
      },
      child: Container(
        width: isCenter ? 151.0 : 110.0,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: AppDimens.font12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Future<T?> showErrorDialog<T>(String message) {
  return Get.dialog(
    CommonDialog(
      message: message,
      isShowInfoIcon: true,
      iconType: IconType.infoRed,
      dialogType: DialogType.white,
      rightButtonText: 'ok'.tr,
    ),
  );
}

Future<void> showInputErrorDialog() {
  return Get.dialog(
    CommonDialog(
      message: 'input_error'.tr,
      isShowInfoIcon: true,
      iconType: IconType.infoGray,
      dialogType: DialogType.white,
      rightButtonText: 'ok'.tr,
    ),
  );
}

Future<void> showCannotModifiedDialog() {
  return showErrorDialog('cannot_modified'.tr);
}

Future<void> showErrorSelectDateDialog() {
  return showErrorDialog('error_select_date_message'.tr);
}

Future<void> showErrorPermissionDialog() {
  return Get.dialog(
    CommonDialog(
      message: 'permission_error_message'.tr,
      isShowInfoIcon: true,
      iconType: IconType.infoRed,
      dialogType: DialogType.white,
      rightButtonText: 'ok'.tr,
    ),
  );
}

enum IconType {
  infoGray,
  infoWhite,
  infoRed,
}

enum DialogType {
  black,
  white,
}
