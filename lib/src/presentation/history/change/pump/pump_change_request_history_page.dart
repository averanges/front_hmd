import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/domain/model/history/change/change_request_data.dart';
import 'package:haimdall/src/presentation/common/loading/loading.dart';
import 'package:haimdall/src/presentation/history/change/pump/pump_change_request_history_controller.dart';
import 'package:intl/intl.dart';

class PumpChangeRequestHistoryPage
    extends GetView<PumpChangeRequestHistoryController> {
  const PumpChangeRequestHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PumpChangeRequestHistoryController>(
      init: PumpChangeRequestHistoryController(
        farmlandId: Get.arguments['farmlandId'],
        repository: Get.find(),
      ),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _titleView(),
                  Expanded(
                    child: Obx(
                      () => controller.data.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 30.0,
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final item = controller.data[index];
                                  return _listItemView(item);
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 25.0),
                                itemCount: controller.data.length,
                              ),
                            )
                          : Center(
                              child: Text(
                                'change_request_history_empty'.tr,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: AppColors.textLabel1st,
                                ),
                              ),
                            ),
                    ),
                  ),
                  _bottomView(),
                ],
              ),
              if (controller.isLoading.value)
                const LoadingWidget(
                  isLoading: true,
                ),
            ],
          ),
        ),
      ),
    );
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
                    controller.onBackPressed();
                  },
                ),
                const Spacer(),
              ],
            ),
            TitleView(title: 'my_page_menu_pump_change_history'.tr),
          ],
        ),
      );

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
          controller.onBackPressed();
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
              'ok'.tr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.font16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget _listItemView(PumpChangeData data) => Container(
        height: 52.0,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            const BoxShadow(
              color: AppColors.shadow,
              offset: Offset(0.0, 1.0),
              blurRadius: 3.0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              DateFormat('yyyy.MM.dd.').format(data.createdAt),
              style: const TextStyle(
                color: AppColors.textLabel1st,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const Spacer(),
            Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: data.status.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5.0),
            Text(
              data.status.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
                color: AppColors.farmlandStatusTextColor,
              ),
            ),
          ],
        ),
      );
}
