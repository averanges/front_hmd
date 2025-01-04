import 'package:get/get.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfController extends GetxController {
  final isLoading = true.obs;

  void onBackPressed() {
    Get.back();
  }

  void onDocumentLoaded() {
    isLoading.value = false;
  }

  void onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    isLoading.value = false;
    showErrorDialog(details.description);
  }
}
