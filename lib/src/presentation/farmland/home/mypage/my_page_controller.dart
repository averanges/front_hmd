import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haimdall/src/common/language/languages.dart';
import 'package:haimdall/src/common/logger/logger.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/repository/auth/auth_repository.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/farmland/home/farmland_home_controller.dart';
import 'package:haimdall/src/presentation/farmland/home/mypage/my_page.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPageController extends GetxController {
  final AuthRepository authRepository;
  final SignupRepository signupRepository;
  final StorageManager storageManager;
  final userName = ''.obs;
  final appVersion = ''.obs;
  final isAlarmEnabled = true.obs;

  MyPageController({
    required this.authRepository,
    required this.signupRepository,
    required this.storageManager,
  });

  var _privacyUrl = '';
  var _serviceUrl = '';

  @override
  onReady() async {
    super.onReady();
    userName.value = storageManager.getValue(
      key: StorageManager.displayName,
      defaultValue: '',
    );

    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = '${packageInfo.version} (${packageInfo.buildNumber})';

    _fetchTermsUrls();

    final userInfo = await signupRepository.getUserInfo();
    if (userInfo.isRight) {
      isAlarmEnabled.value = userInfo.right.alarmControlled;
    }
  }

  void _fetchTermsUrls() async {
    var result = await signupRepository.getPrivacyPolicyTermsUrl();

    if (result.isLeft) {
      showErrorDialog(result.left.message);
      return;
    }
    _privacyUrl = result.right;

    result = await signupRepository.getServiceTermsUrl();
    if (result.isLeft) {
      showErrorDialog(result.left.message);
      return;
    }
    _serviceUrl = result.right;
  }

  void onClickedMenu(MyPageMenu menu) {
    switch (menu) {
      case MyPageMenu.awdChange:
        Get.toNamed(
          AppRoute.awdScheduleChangeRequest,
          arguments: {
            'farmlandId': Get.find<FarmlandHomeController>().farmlandId,
          },
        );
        break;
      case MyPageMenu.awdChangeHistory:
        Get.toNamed(
          AppRoute.awdChangeRequestHistory,
          arguments: {
            'farmlandId': Get.find<FarmlandHomeController>().farmlandId,
          },
        );
      case MyPageMenu.pumpChange:
        Get.toNamed(
          AppRoute.pumpScheduleChangeRequest,
          arguments: {
            'farmlandId': Get.find<FarmlandHomeController>().farmlandId,
          },
        );
        break;
      case MyPageMenu.pumpChangeHistory:
        Get.toNamed(
          AppRoute.pumpChangeRequestHistory,
          arguments: {
            'farmlandId': Get.find<FarmlandHomeController>().farmlandId,
          },
        );
        break;
      case MyPageMenu.faq:
        Get.toNamed(
          AppRoute.web,
          arguments: {
            'title': menu.name,
            'url': _getFaqUrl(),
          },
        );
        break;
      case MyPageMenu.termsService:
        Get.toNamed(
          _serviceUrl.contains('.pdf') ? AppRoute.pdf : AppRoute.web,
          arguments: {'title': 'terms_service'.tr, 'url': _serviceUrl},
        );
        break;
      case MyPageMenu.termsPrivacy:
        Get.toNamed(
          _privacyUrl.contains('.pdf') ? AppRoute.pdf : AppRoute.web,
          arguments: {'title': 'terms_privacy'.tr, 'url': _privacyUrl},
        );
        break;
      case MyPageMenu.qna:
        _showEmailApp();
        break;
      case MyPageMenu.awdEdu:
        Get.toNamed(AppRoute.awd);
        break;
      case MyPageMenu.language:
        Get.toNamed(AppRoute.localizationPage);
        break;
      case MyPageMenu.tutorial:
        Get.toNamed(
          AppRoute.onboarding,
          arguments: {
            'nextToBack': true,
          },
        );
        break;
      case MyPageMenu.logout:
        _showLogoutPopup();
        break;
      case MyPageMenu.withdraw:
        _showWithdrawPopup();
        break;
      default:
        // Do Nothing
        break;
    }
  }

  void onClickedChangeRequestHistory() {
    // AWD 일정 변경 요청 내역 화면 이동
    Get.toNamed(
      AppRoute.awdChangeRequestHistory,
      arguments: {
        'farmlandId': Get.find<FarmlandHomeController>().farmlandId,
      },
    );
  }

  void onClickedNotification(bool value) async {
    final result = await authRepository.changeAlarmControl(value);

    if (result.isLeft) {
      showErrorDialog(result.left.message);
      return;
    }

    isAlarmEnabled.value = value;
  }

  void _showLogoutPopup() {
    Get.dialog(
      CommonDialog(
        titleText: 'my_page_menu_logout'.tr,
        message: 'logout_desc'.tr,
        isShowInfoIcon: false,
        rightButtonText: 'logout'.tr,
        onRightButtonClicked: () async {
          final userId = storageManager.userId;
          await storageManager.clear();
          await FirebaseAuth.instance.signOut();
          if (userId.contains('google')) {
            await GoogleSignIn().signOut();
          }

          Get.offAllNamed(AppRoute.loginPage);
          injectRepositories();
        },
        leftButtonText: 'cancel'.tr,
      ),
    );
  }

  void _showWithdrawPopup() {
    Get.dialog(
      CommonDialog(
        titleText: 'withdraw'.tr,
        message: 'withdraw_desc'.tr,
        isShowInfoIcon: false,
        rightButtonText: 'withdraw'.tr,
        onRightButtonClicked: () async {
          final userId = storageManager.userId;
          final result = await authRepository.withdraw();
          if (result.isLeft) {
            showErrorDialog(result.left.message);
            return;
          }
          await storageManager.clear();
          await FirebaseAuth.instance.signOut();
          if (userId.contains('google')) {
            await GoogleSignIn().signOut();
          }

          Get.offAllNamed(AppRoute.loginPage);
          injectRepositories();
        },
        leftButtonText: 'cancel'.tr,
      ),
    );
  }

  void _showEmailApp() async {
    final email = Email(
      recipients: ['revudn46@thankscarbon.com'],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      var errorMessage = '';
      if (error is PlatformException) {
        errorMessage = error.message ?? '';
      }
      Log.e('show email app error', error);
      try {
        await launchUrl(Uri.parse('mailto:revudn46@thankscarbon.com'));
      } catch (error) {
        Log.e('launch email app error', error);
        showErrorDialog(
          '기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요\n\nrevudn46@thankscarbon.com\n\n[$errorMessage]',
        );
      }
    }
  }

  String _getFaqUrl() {
    switch (Get.locale) {
      // 한국
      case const Locale('ko_KR'):
        return Languages.korean.faqUrl;
      // 미국
      case const Locale('en_US'):
        return Languages.english.faqUrl;
      // 베트남
      case const Locale('vi_VN'):
        return Languages.vietnamese.faqUrl;
      // 캄보디아
      case const Locale('km_KH'):
        return Languages.cambodian.faqUrl;
      // 방글라데시
      case const Locale('bn_BD'):
        return Languages.bangladeshi.faqUrl;
      default:
        return Languages.korean.faqUrl;
    }
  }
}
