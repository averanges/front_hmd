import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';

enum Fertilizer implements HaimdallDropdownData {
  type1,
  type2;

  @override
  String toName() {
    switch (this) {
      case Fertilizer.type1:
        return 'TYPE1';
      case Fertilizer.type2:
        return 'TYPE2';
      default:
        return '';
    }
  }

  @override
  String toApiValue() {
    switch (this) {
      case Fertilizer.type1:
        return 'TYPE1';
      case Fertilizer.type2:
        return 'TYPE2';
      default:
        return '';
    }
  }
}
