import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/logger/logger.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/model/signup/user/signed_up_user_info.dart';
import 'package:haimdall/src/domain/repository/auth/auth_repository.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:haimdall/src/presentation/splash/permission_sheet/permission_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  var _permissions = <Permission>[];

  final SignupRepository repository;
  final AuthRepository authRepository;
  final StorageManager storageManager;

  SplashController({
    required this.repository,
    required this.authRepository,
    required this.storageManager,
  });

  @override
  void onReady() async {
    super.onReady();

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    if (storageManager.localeText.isNotEmpty) {
      final locale = Locale(storageManager.localeText);
      Get.updateLocale(locale);
    } else {
      Get.updateLocale(const Locale('ko'));
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final androidOSVersion = int.parse(androidInfo.version.release);

      if (androidOSVersion < 13) {
        _permissions = [
          Permission.camera,
          Permission.storage,
          Permission.location,
          Permission.locationWhenInUse,
        ];
      } else {
        _permissions = [
          Permission.camera,
          Permission.photos,
          Permission.location,
          Permission.locationWhenInUse,
        ];
      }
    } else if (GetPlatform.isIOS) {
      _permissions = [
        Permission.camera,
        Permission.photos,
        Permission.location,
        Permission.locationWhenInUse,
      ];
    }

    await _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var isGrantedAll = true;

    for (var permission in _permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        isGrantedAll = false;
      }
    }

    if (isGrantedAll) {
      final userId = storageManager.userId;

      if (userId.isEmpty) {
        Get.offNamed(AppRoute.loginPage);
        injectRepositories();
      } else {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        Log.d('[FCM] token: $fcmToken');
        if (fcmToken != null) {
          await Get.find<AuthRepository>().updateFcmToken(fcmToken);
        }

        final result = await repository.getUserInfo();

        if (result.isLeft) {
          showErrorDialog(result.left.message).then(
            (value) {
              Get.offNamed(AppRoute.loginPage);
              injectRepositories();
            },
          );
        } else {
          switch (result.right.status) {
            case UserStatus.approved:
              if (result.right.completedTutorial) {
                Get.offNamed(
                  AppRoute.farmlandList,
                  arguments: Get.arguments,
                );
              } else {
                Get.offNamed(AppRoute.onboarding);
              }
              break;
            case UserStatus.rejected:
              Get.offNamed(AppRoute.signupRejected);
              break;
            case UserStatus.pending:
              Get.offNamed(AppRoute.signupWaiting);
              break;
            case UserStatus.unrequested:
              Get.offNamed(AppRoute.loginPage);
              break;
          }
          injectRepositories();
        }
      }
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Get.bottomSheet(
            const PermissionSheet(),
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            enterBottomSheetDuration: const Duration(milliseconds: 300),
          );
        },
      );
    }
  }

// 권한 요청
  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await _permissions.request();

    final results = statuses.values.map((status) {
      return status.isGranted;
    }).toList();

    var isGrantedAll = results.reduce((value, element) => value && element);

    if (isGrantedAll) {
      Get.offNamed(AppRoute.loginPage);
      injectRepositories();
    } else {
      Get.dialog(
        CommonDialog(
          message: 'permission_error_message'.tr,
          isShowInfoIcon: true,
          iconType: IconType.infoRed,
          dialogType: DialogType.white,
          rightButtonText: 'move_setting'.tr,
          onRightButtonClicked: () {
            openAppSettings();
          },
          leftButtonText: 'ok'.tr,
        ),
      );
    }
  }
}
