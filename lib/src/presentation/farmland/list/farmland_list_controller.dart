import 'package:get/get.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/model/farmland/farmland.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class FarmlandListController extends GetxController {
  final StorageManager storageManager;

  FarmlandListController({
    required this.storageManager,
  });

  final enabledButton = false.obs;
  final farmlandList = <Farmland>[].obs;
  final selectedFarmland = Rxn<Farmland>();

  @override
  void onReady() async {
    super.onReady();

    var farmlandId = Get.arguments?['farmlandId'];
    if (farmlandId is String) {
      farmlandId = int.tryParse(farmlandId);
    }
    if (farmlandId != null) {
      await _fetchFarmlandList();

      final findData = farmlandList
          .firstWhereOrNull((element) => element.farmlandId == farmlandId);

      if (findData != null) {
        storageManager.setValue(
          key: StorageManager.displayName,
          value: findData.ownerName,
        );
      }

      await Future.delayed(const Duration(milliseconds: 500));

      Get.toNamed(
        AppRoute.farmlandHome,
        arguments: {
          'farmlandId': farmlandId,
        },
      )?.then((_) {
        _fetchFarmlandList();
      });
    } else {
      await _fetchFarmlandList();
    }
  }

  void onRefresh() async {
    await _fetchFarmlandList();
  }

  Future<void> _fetchFarmlandList() async {
    FarmlandRepository? repository;
    try {
      repository = Get.find<FarmlandRepository>();
    } catch (e) {
      injectRepositories();
      repository = Get.find<FarmlandRepository>();
    }

    final result = await repository.getFarmlandList();
    if (result.isLeft) {
      showErrorDialog(result.left.message);
    } else {
      farmlandList.value = result.right;
    }
  }

  void onClickedAddFarmland() {
    Get.toNamed(AppRoute.farmlandAdd)?.then((value) async {
      if (value == true) {
        await _fetchFarmlandList();
      }
    });
  }

  void onClickedFarmland(Farmland? data) {
    if (data?.status == FarmlandStatus.approved) {
      selectedFarmland.value = data;
    }
    enabledButton.value = selectedFarmland.value != null;
  }

  void onClickedOkButton() {
    if (enabledButton.value == true) {
      storageManager.setValue(
        key: StorageManager.displayName,
        value: selectedFarmland.value?.ownerName ?? '',
      );

      Get.toNamed(
        AppRoute.farmlandHome,
        arguments: {
          'farmlandId': selectedFarmland.value?.farmlandId ?? -1,
        },
      )?.then((_) {
        _fetchFarmlandList();
      });
    }
  }

  void onClickedAddPhotoButton(int farmlandId) {
    Get.toNamed(AppRoute.farmlandAddPhoto, arguments: {
      'farmlandId': farmlandId,
    })?.then((result) async {
      if (result == true) {
        await _fetchFarmlandList();
      }
    });
  }
}
