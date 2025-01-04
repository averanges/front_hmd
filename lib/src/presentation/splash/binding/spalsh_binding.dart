import 'package:get/get.dart';
import 'package:haimdall/src/presentation/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController(
      repository: Get.find(),
      authRepository: Get.find(),
      storageManager: Get.find(),
    ));
  }
}
