import 'package:get/get.dart';
import 'package:haimdall/src/presentation/localization/localization_controller.dart';

class LocalizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocalizationController(storageManager: Get.find()));
  }
}
