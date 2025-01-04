import 'package:get/get.dart';
import 'package:haimdall/src/domain/model/history/change/change_request_data.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';

class AwdChangeRequestHistoryController extends GetxController {
  final FarmlandRepository repository;
  final int farmlandId;

  AwdChangeRequestHistoryController({
    required this.repository,
    required this.farmlandId,
  });

  final isLoading = false.obs;
  final data = RxList<AwdChangeData>();

  @override
  void onReady() {
    super.onReady();

    _fetchChangeRequestHistory();
  }

  void onBackPressed() {
    // 뒤로가기
    Get.back();
  }

  void onRefresh() {
    // 새로고침
    _fetchChangeRequestHistory();
  }

  void _fetchChangeRequestHistory() async {
    // 변경 요청 내역 조회
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    final result = await repository.getAwdChangeRequestList(farmlandId);

    isLoading.value = false;
    if (result.isLeft) {
      // 에러 발생
      showErrorDialog(result.left.message);
      return;
    }

    // 성공
    data.value = result.right;
  }
}
