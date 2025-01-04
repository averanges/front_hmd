import 'package:get/get.dart';
import 'package:haimdall/src/presentation/terms/terms_controller.dart';

class TermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TermsController(repository: Get.find()));
  }
}
