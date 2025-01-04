import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:haimdall/env/resources/resources.dart';

enum FarmlandCalendarEventType {
  pumpOn,
  pumpOff,
  drainWaterStart,
  drainWaterEnd;
}

extension FarmlandCalendarEventTypeExtension on FarmlandCalendarEventType {
  Color get color {
    switch (this) {
      case FarmlandCalendarEventType.pumpOn:
        return AppColors.descPumpOn;
      case FarmlandCalendarEventType.pumpOff:
        return AppColors.descPumpOff;
      case FarmlandCalendarEventType.drainWaterStart:
        return AppColors.descStartDrainWater;
      case FarmlandCalendarEventType.drainWaterEnd:
        return AppColors.descEndDrainWater;
    }
  }

  String get name {
    switch (this) {
      case FarmlandCalendarEventType.pumpOn:
        return 'record_calendar_event_pump_on'.tr;
      case FarmlandCalendarEventType.pumpOff:
        return 'record_calendar_event_pump_off'.tr;
      case FarmlandCalendarEventType.drainWaterStart:
        return 'record_calendar_event_start_drain_water'.tr;
      case FarmlandCalendarEventType.drainWaterEnd:
        return 'record_calendar_event_end_drain_water'.tr;
    }
  }
}
