import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/domain/model/farmland/farmland.dart';
import 'package:haimdall/src/presentation/farmland/list/farmland_list_controller.dart';

class FarmlandItem extends GetView<FarmlandListController> {
  final Farmland data;

  const FarmlandItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.onClickedFarmland(data);
      },
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: controller.selectedFarmland.value?.farmlandId ==
                      data.farmlandId
                  ? AppColors.selectedFarmlandBorder
                  : AppColors.white,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3.0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    data.ownerName,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
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
                    data.status.name,
                    style: const TextStyle(
                      height: 2.0,
                      fontSize: 10.0,
                      color: AppColors.farmlandStatusTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17.0),
              (data.status == FarmlandStatus.photoRequired ||
                      data.status == FarmlandStatus.rejected)
                  ? _photoButton()
                  : _locationWidget(data.latitude, data.longitude),
            ],
          ),
        ),
      ),
    );
  }

  // 사진 촬영 버튼
  Widget _photoButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onClickedAddPhotoButton(data.farmlandId);
        },
        child: Container(
          width: double.infinity,
          height: 32,
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
              'take_picture'.tr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppDimens.font12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  // 위도 경도
  Widget _locationWidget(double latitude, double longitude) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _rowLocation('latitude'.tr, latitude),
          const SizedBox(height: 5.0),
          _rowLocation('longitude'.tr, longitude),
        ],
      );

  Widget _rowLocation(String name, double data) => Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textLabel1st,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            data.toString(),
            style: const TextStyle(
              color: AppColors.textLabel1st,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ],
      );
}
