import 'package:get/get.dart';
import 'package:haimdall/src/presentation/onbaoarding/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      OnboardingController(
        repository: Get.find(),
        storageManager: Get.find(),
      ),
    );
  }
}
