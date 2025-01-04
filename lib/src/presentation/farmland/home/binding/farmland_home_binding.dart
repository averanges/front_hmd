import 'package:get/get.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/presentation/farmland/home/farmland_home_controller.dart';

class FarmLandHomeBinding extends Bindings {
  @override
  void dependencies() {
    injectRepositories();
    Get.put(FarmlandHomeController());
  }
}
