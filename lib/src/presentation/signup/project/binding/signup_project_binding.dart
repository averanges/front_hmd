import 'package:get/get.dart';
import 'package:haimdall/src/presentation/signup/project/signup_project_controller.dart';

class SignupProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignupProjectController());
  }
}
