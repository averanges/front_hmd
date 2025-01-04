import 'package:get/get.dart';

import 'bd/string.dart';
import 'en/string.dart';
import 'kh/string.dart';
import 'ko/string.dart';
import 'vi/string.dart';

class Strings extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // 한국어
        'ko_KR': koString,
        // 영어
        'en_US': enString,
        // 베트남
        'vi_VN': viString,
        // 방글라데시
        'bn_BD': bdString,
        // 캄보디아
        'km_KH': khString,
      };
}
