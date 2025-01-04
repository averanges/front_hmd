import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';

class CalendarRangeItem extends StatelessWidget {
  final RxBool isShowLunarDate;
  final DateTime day;
  final CalendarRangeType type;
  final CalendarRangeColor color;

  const CalendarRangeItem({
    super.key,
    required this.isShowLunarDate,
    required this.day,
    required this.type,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isShowLunarDate = this.isShowLunarDate.value;

      return Center(
        child: Container(
          margin: EdgeInsets.only(
            bottom: isShowLunarDate ? 15.0 : 0.0,
          ),
          height: isShowLunarDate ? 20.0 : 17.0,
          decoration: type == CalendarRangeType.start
              ? _startDecoration()
              : type == CalendarRangeType.middle
                  ? _middleDecoration()
                  : _endDecoration(),
          child: isShowLunarDate
              ? Container()
              : Center(
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color: AppColors.calendarDefaultDay,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      );
    });
  }

  BoxDecoration _startDecoration() {
    return BoxDecoration(
      color: color.color,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(100.0),
        bottomLeft: Radius.circular(100.0),
      ),
    );
  }

  BoxDecoration _middleDecoration() {
    return BoxDecoration(
      color: color.color,
      shape: BoxShape.rectangle,
    );
  }

  BoxDecoration _endDecoration() {
    return BoxDecoration(
      color: color.color,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(100.0),
        bottomRight: Radius.circular(100.0),
      ),
    );
  }
}

enum CalendarRangeType {
  start,
  middle,
  end;
}

enum CalendarRangeColor {
  pump,
  drainWater;

  Color get color {
    switch (this) {
      case CalendarRangeColor.pump:
        return AppColors.calendarRangePump;
      case CalendarRangeColor.drainWater:
        return AppColors.calendarRangeDrainWater;
    }
  }
}
