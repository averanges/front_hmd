import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/common/loading/loading.dart';
import 'package:haimdall/src/presentation/web/pdf/pdf_controller.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPage extends GetView<PdfController> {
  const PdfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfController>(
        init: PdfController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (canPop, result) {
                  if (canPop == false) {
                    controller.onBackPressed();
                  }
                },
                child: Stack(
                  children: [
                    Container(color: AppColors.white),
                    Column(
                      children: [
                        _titleView(),
                        _lineView(),
                        Expanded(
                          child: SfPdfViewerTheme(
                            data: const SfPdfViewerThemeData(
                              backgroundColor: AppColors.white,
                            ),
                            child: SfPdfViewer.network(
                              Get.arguments['url'] ?? '',
                              onDocumentLoaded:
                                  (PdfDocumentLoadedDetails details) {
                                controller.onDocumentLoaded();
                              },
                              onDocumentLoadFailed:
                                  (PdfDocumentLoadFailedDetails details) {
                                controller.onDocumentLoadFailed(details);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () =>
                          LoadingWidget(isLoading: controller.isLoading.value),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _titleView() => SizedBox(
        height: 44.0,
        child: Stack(
          children: [
            Row(
              children: [
                const SizedBox(width: 25.0),
                IconButton(
                  icon: AppImages.icBack,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Get.back();
                  },
                ),
                const Spacer(),
              ],
            ),
            Center(
              child: Text(
                Get.arguments['title'] ?? '',
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);
}
