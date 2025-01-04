import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AwdPage extends StatelessWidget {
  const AwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Title
            _titleView(),
            _lineView(),
            Expanded(
              child: SfPdfViewerTheme(
                data: const SfPdfViewerThemeData(
                  backgroundColor: AppColors.white,
                ),
                child: SfPdfViewer.asset(
                  _pdfPath,
                ),
              ),
            ),
            // Bottom Button
            _bottomView(),
          ],
        ),
      ),
    );
  }

  String get _pdfPath {
    switch (Get.locale) {
      case const Locale('ko_KR'):
        return 'assets/pdfs/awd_edu_ko.pdf';
      // 미국
      case const Locale('en_US'):
        return 'assets/pdfs/awd_edu_en.pdf';
      // 베트남
      case const Locale('vi_VN'):
        return 'assets/pdfs/awd_edu_vi.pdf';
      // 캄보디아
      case const Locale('km_KH'):
        return 'assets/pdfs/awd_edu_kh.pdf';
      // 방글라데시
      case const Locale('bn_BD'):
        return 'assets/pdfs/awd_edu_bd.pdf';
      default:
        return 'assets/pdfs/awd_edu_ko.pdf';
    }
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
            TitleView(title: 'awd_title'.tr),
          ],
        ),
      );

  Widget _lineView() => Container(height: 1.0, color: AppColors.line);

  Widget _bottomView() => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 33.0,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(0.0, -2.0),
                blurRadius: 7.2,
                blurStyle: BlurStyle.outer,
              )
            ]),
        child: _okButton(),
      );

  Widget _okButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (Get.arguments?['isTutorial'] == true) {
            Get.offAllNamed(AppRoute.farmlandList);
            injectRepositories();
          } else {
            Get.back();
          }
        },
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.enabledButton,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.snsLoginBorder,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              Get.arguments?['isTutorial'] == true ? 'next'.tr : 'ok'.tr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.font16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
