import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/common/components/title_view.dart';
import 'package:haimdall/src/presentation/farmland/list/farmland_list_controller.dart';
import 'package:haimdall/src/presentation/farmland/list/item/farmland_item.dart';
import 'package:haimdall/src/presentation/farmland/list/item/farmland_list_add_item.dart';

class FarmlandListPage extends GetView<FarmlandListController> {
  const FarmlandListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            _titleView(),
            _lineView(),
            SizedBox(height: Get.height * 0.0375),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Obx(
                  () => CustomMaterialIndicator(
                    onRefresh: () async => controller.onRefresh(),
                    backgroundColor: AppColors.white,
                    indicatorBuilder: (context, controller) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircularProgressIndicator(
                          color: AppColors.mainBlue,
                          value: controller.state.isLoading
                              ? null
                              : min(controller.value, 1.0),
                        ),
                      );
                    },
                    child: ListView.separated(
                      itemCount: controller.farmlandList.length + 1,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 25.0);
                      },
                      itemBuilder: (context, index) {
                        if (index == controller.farmlandList.length) {
                          return const FarmlandListAddItem();
                        } else {
                          return FarmlandItem(
                            data: controller.farmlandList[index],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.0375),
            _bottomView(),
          ],
        ),
      ),
    );
  }

  Widget _titleView() => SizedBox(
        height: 44.0,
        child: TitleView(title: 'farmland_list_title'.tr),
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
          controller.onClickedOkButton();
        },
        child: Obx(
          () => Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: controller.enabledButton.value
                  ? AppColors.enabledButton
                  : AppColors.disabledButton,
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
        ),
      );
}
