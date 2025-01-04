import 'package:get/get.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/presentation/farmland/list/farmland_list_controller.dart';

class FarmlandListBinding extends Bindings {
  @override
  void dependencies() {
    injectRepositories();
    Get.put(FarmlandListController(
      storageManager: Get.find(),
    ));
  }
}
