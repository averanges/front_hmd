import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';

enum RiceCultivar implements HaimdallDropdownData {
  rice1,
  rice2;

  @override
  String toName() {
    switch (this) {
      case RiceCultivar.rice1:
        return 'RICE1';
      case RiceCultivar.rice2:
        return 'RICE2';
      default:
        return '';
    }
  }

  static RiceCultivar? fromString(String value) {
    switch (value) {
      case 'RICE1':
        return RiceCultivar.rice1;
      case 'RICE2':
        return RiceCultivar.rice2;
      default:
        return null;
    }
  }

  @override
  String toApiValue() {
    switch (this) {
      case RiceCultivar.rice1:
        return 'RICE1';
      case RiceCultivar.rice2:
        return 'RICE2';
      default:
        return '';
    }
  }
}
