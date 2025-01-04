class FarmlandWateringRequest {
  final int farmlandId;
  final List<PumpDateRequest> pumpDates;

  FarmlandWateringRequest({
    required this.farmlandId,
    required this.pumpDates,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmland_id': farmlandId,
      'pump_dates': pumpDates.map((e) => e.toJson()).toList(),
    };
  }
}

class PumpDateRequest {
  final DateTime pumpOnDate;
  final DateTime pumpOffDate;

  PumpDateRequest({
    required this.pumpOnDate,
    required this.pumpOffDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'pump_on_date': pumpOnDate.toIso8601String(),
      'pump_off_date': pumpOffDate.toIso8601String(),
    };
  }
}
