import 'package:get/get.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class TermsController extends GetxController {
  final SignupRepository repository;

  TermsController({
    required this.repository,
  });

  final enableButton = false.obs;
  final isCheckedTermsPrivacy = false.obs;
  final isCheckedTermsService = false.obs;

  var _privacyUrl = '';
  var _serviceUrl = '';

  @override
  void onReady() {
    super.onReady();

    _fetchTermsUrls();
  }

  void _fetchTermsUrls() async {
    var result = await repository.getPrivacyPolicyTermsUrl();

    if (result.isLeft) {
      showErrorDialog(result.left.message);
      return;
    }
    _privacyUrl = result.right;

    result = await repository.getServiceTermsUrl();
    if (result.isLeft) {
      showErrorDialog(result.left.message);
      return;
    }
    _serviceUrl = result.right;
  }

  void onClickedNextButton() {
    if (enableButton.value == false) {
      Get.dialog(
        CommonDialog(
          message: 'terms_next_error_message'.tr,
          isShowInfoIcon: true,
          iconType: IconType.infoWhite,
          dialogType: DialogType.black,
          rightButtonText: 'ok'.tr,
        ),
      );
      return;
    }

    Get.toNamed(AppRoute.signup);
  }

  void onClickedTermsPrivacy() {
    isCheckedTermsPrivacy.value = !isCheckedTermsPrivacy.value;
    _checkCondition();
  }

  void onClickedTermsService() {
    isCheckedTermsService.value = !isCheckedTermsService.value;
    _checkCondition();
  }

  void _checkCondition() {
    enableButton.value =
        isCheckedTermsPrivacy.value && isCheckedTermsService.value;
  }

  void onClickedMoveTermsPrivacy() {
    Get.toNamed(
      _privacyUrl.contains('.pdf') ? AppRoute.pdf :AppRoute.web,
      arguments: {'title': 'terms_privacy'.tr, 'url': _privacyUrl},
    );
  }

  void onClickedMoveTermsService() {
    Get.toNamed(
      _serviceUrl.contains('.pdf') ? AppRoute.pdf :AppRoute.web,
      arguments: {'title': 'terms_service'.tr, 'url': _serviceUrl},
    );
  }
}
