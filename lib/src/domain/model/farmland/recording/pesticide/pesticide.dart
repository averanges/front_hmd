import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';

enum Pesticide implements HaimdallDropdownData {
  type1,
  type2;

  @override
  String toName() {
    switch (this) {
      case Pesticide.type1:
        return 'TYPE1';
      case Pesticide.type2:
        return 'TYPE2';
      default:
        return '';
    }
  }

  @override
  String toApiValue() {
    switch (this) {
      case Pesticide.type1:
        return 'TYPE1';
      case Pesticide.type2:
        return 'TYPE2';
      default:
        return '';
    }
  }
}
