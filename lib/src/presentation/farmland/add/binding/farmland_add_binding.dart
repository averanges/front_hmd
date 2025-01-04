import 'package:get/get.dart';
import 'package:haimdall/src/presentation/farmland/add/farmland_add_controller.dart';

class FarmlandAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FarmlandAddController());
  }
}
