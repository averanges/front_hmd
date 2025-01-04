import 'package:get/get.dart';
import 'package:haimdall/src/presentation/signup/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
  }
}
