class FarmlandChangeScheduleRequest {
  final int farmlandId;
  final List<ChangeScheduleDateRequest> changeDate;
  final String changeReason;

  FarmlandChangeScheduleRequest({
    required this.farmlandId,
    required this.changeDate,
    required this.changeReason,
  });

  Map<String, dynamic> toAwdJson() {
    return {
      'farmland_id': farmlandId,
      'change_date': changeDate.map((e) => e.toAwdJson()).toList(),
      'change_reason': changeReason,
    };
  }

  Map<String, dynamic> toPumpJson() {
    return {
      'farmland_id': farmlandId,
      'pump_date': changeDate.map((e) => e.toPumpJson()).toList(),
      'change_reason': changeReason,
    };
  }
}

class ChangeScheduleDateRequest {
  final DateTime waterDrainStartDate;
  final DateTime waterDrainEndDate;

  ChangeScheduleDateRequest({
    required this.waterDrainStartDate,
    required this.waterDrainEndDate,
  });

  Map<String, dynamic> toAwdJson() {
    return {
      'water_drain_start_date': waterDrainStartDate.toIso8601String(),
      'water_drain_end_date': waterDrainEndDate.toIso8601String(),
    };
  }

  Map<String, dynamic> toPumpJson() {
    return {
      'pump_on_date': waterDrainStartDate.toIso8601String(),
      'pump_off_date': waterDrainEndDate.toIso8601String(),
    };
  }
}
