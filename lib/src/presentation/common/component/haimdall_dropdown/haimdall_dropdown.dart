import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown_controller.dart';

class HaimdallDropdown<T extends HaimdallDropdownData>
    extends GetView<HaimdallDropdownController<T>> {
  final List<HaimdallDropdownItem<T>> items;
  final Rxn<T> selectedValue;
  final String hintText;

  const HaimdallDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HaimdallDropdownController<T>>(
      init: HaimdallDropdownController<T>(),
      builder: (_) => CompositedTransformTarget(
        link: controller.link,
        child: OverlayPortal(
          controller: controller.tooltipController,
          overlayChildBuilder: (BuildContext context) {
            return CompositedTransformFollower(
              link: controller.link,
              targetAnchor: Alignment.bottomLeft,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: HaimdallDropdownMenuWidget(
                  itemWidth: Get.width - 52.0,
                  itemHeight: 40.0,
                  items: items,
                  onTap: (value) {
                    controller.onTap();
                  },
                ),
              ),
            );
          },
          child: HaimdallDropdownButtonWidget<T>(
            onTap: controller.onTap,
            selectedValue: selectedValue,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}

class HaimdallDropdownButtonWidget<T extends HaimdallDropdownData>
    extends GetView<HaimdallDropdownController<T>> {
  final Rxn<T> selectedValue;
  final double? height;
  final double? width;

  final VoidCallback? onTap;

  final Widget? child;
  final String hintText;

  const HaimdallDropdownButtonWidget({
    super.key,
    this.height = 40,
    this.width,
    this.onTap,
    this.child,
    required this.selectedValue,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final data = selectedValue.value;
        final isShowingMenu = controller.isShowingMenu.value;

        return Container(
          width: double.infinity,
          height: 40.0,
          decoration: BoxDecoration(
            color: data == null
                ? AppColors.textFieldBg
                : AppColors.textFieldValidBg,
            borderRadius: !isShowingMenu
                ? BorderRadius.circular(5.0)
                : const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                  ),
            border: data == null
                ? null
                : Border.all(
                    color: AppColors.focusedTextFieldStroke,
                    width: 1.0,
                  ),
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              borderRadius: !isShowingMenu
                  ? BorderRadius.circular(5.0)
                  : const BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                    ),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Row(
                  children: [
                    Text(
                      data == null ? hintText : data.toName(),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: data == null
                            ? AppColors.textLabel2nd
                            : AppColors.textLabel1st,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    AppImages.angleDownIcon,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HaimdallDropdownMenuWidget<T> extends StatelessWidget {
  const HaimdallDropdownMenuWidget({
    super.key,
    this.itemWidth,
    this.itemHeight = 40.0,
    required this.items,
    this.onTap,
  });

  final double? itemWidth;
  final double itemHeight;
  final List<HaimdallDropdownItem<T>> items;
  final ValueChanged<T>? onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container();
    }
    return Container(
      width: itemWidth ?? Get.width - 52.0,
      height: min((items.length * itemHeight + (items.length - 1)) , 200.0),
      padding: const EdgeInsets.all(1.0),
      decoration: const ShapeDecoration(
        color: AppColors.textFieldBg,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.0,
            color: AppColors.dropdownBorder,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 32,
            offset: Offset(0, 20),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Material(
            color: AppColors.textFieldBg,
            child: InkWell(
              onTap: () {
                onTap?.call(item.value);
                item.onSelected?.call(item.value);
              },
              child: Container(
                width: itemWidth ?? Get.width - 52.0,
                height: itemHeight,
                color: AppColors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${index + 1}. ${item.label}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textLabel1st,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.grey,
            height: 1,
          );
        },
      ),
    );
  }
}

class HaimdallDropdownItem<T> {
  final T value;
  final String label;
  final TextStyle? labelStyle;
  final ValueChanged<T?>? onSelected;

  HaimdallDropdownItem({
    required this.value,
    required this.label,
    this.labelStyle,
    this.onSelected,
  });
}

abstract class HaimdallDropdownData {
  String toName();
  String toApiValue();
}
