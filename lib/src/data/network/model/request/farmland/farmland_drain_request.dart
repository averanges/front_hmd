class FarmlandDrainRequest {
  final int farmlandId;
  final List<DrainDateRequest> drainDates;

  FarmlandDrainRequest({
    required this.farmlandId,
    required this.drainDates,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmland_id': farmlandId,
      'drain_dates': drainDates.map((e) => e.toJson()).toList(),
    };
  }
}

class DrainDateRequest {
  final DateTime waterDrainStartDate;
  final DateTime waterDrainEndDate;

  DrainDateRequest({
    required this.waterDrainStartDate,
    required this.waterDrainEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'water_drain_start_date': waterDrainStartDate.toIso8601String(),
      'water_drain_end_date': waterDrainEndDate.toIso8601String(),
    };
  }
}
