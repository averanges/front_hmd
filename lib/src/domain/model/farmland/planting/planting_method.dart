import 'package:get/get.dart';
import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';

enum PlantingMethod implements HaimdallDropdownData {
  handPlanting, // 손 모내기
  machinePlanting; // 기계식 모내기

  static PlantingMethod? fromString(String plantingMethod) {
    switch (plantingMethod.toUpperCase()) {
      case 'HAND_PLANTING':
        return PlantingMethod.handPlanting;
      case 'MACHINE_PLANTING':
        return PlantingMethod.machinePlanting;
      default:
        return null;
    }
  }

  @override
  String toName() {
    switch (this) {
      case PlantingMethod.handPlanting:
        return 'hand_planting'.tr; //'손 모내기';
      case PlantingMethod.machinePlanting:
        return 'machine_planting'.tr; //'기계식 모내기';
    }
  }

  @override
  String toApiValue() {
    switch (this) {
      case PlantingMethod.handPlanting:
        return 'HAND_PLANTING';
      case PlantingMethod.machinePlanting:
        return 'MACHINE_PLANTING';
    }
  }
}
