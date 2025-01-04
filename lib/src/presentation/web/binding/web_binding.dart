import 'package:get/get.dart';
import 'package:haimdall/src/presentation/web/web_controller.dart';

class WebBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WebController());
  }
}
