import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/farmland/list/farmland_list_controller.dart';

class FarmlandListAddItem extends GetView<FarmlandListController> {
  const FarmlandListAddItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 농지 추가
        controller.onClickedAddFarmland();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 16.0,
        ),
        constraints: const BoxConstraints(
          minHeight: 63.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 3.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'farmland_add'.tr,
              style: const TextStyle(
                fontSize: 15.0,
                color: AppColors.textLabel1st,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            AppImages.circlePlusIcon
          ],
        ),
      ),
    );
  }
}
