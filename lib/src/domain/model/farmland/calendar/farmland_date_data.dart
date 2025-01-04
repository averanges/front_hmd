class FarmlandDateData {
  final DateTime? plantingDate;
  final List<WateringDate> wateringDateList;

  FarmlandDateData({
    required this.plantingDate,
    required this.wateringDateList,
  });

  factory FarmlandDateData.fromJson(Map<String, dynamic> json) {
    return FarmlandDateData(
      plantingDate: (json['planting_date'] ?? '') == ''
          ? null
          : DateTime.parse(json['planting_date']),
      wateringDateList: (json['watering_date_list'] as List?)
              ?.map((e) => WateringDate.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class WateringDate {
  final int wateringId;
  final DateTime? pumpOnDate;
  final DateTime? pumpOffDate;
  final DateTime? waterDrainStartDate;
  final DateTime? waterDrainEndDate;

  WateringDate({
    required this.wateringId,
    required this.pumpOnDate,
    required this.pumpOffDate,
    required this.waterDrainStartDate,
    required this.waterDrainEndDate,
  });

  factory WateringDate.fromJson(Map<String, dynamic> json) {
    return WateringDate(
      wateringId: json['watering_id'] ?? -1,
      pumpOnDate: json['pump_on_date'] == null
          ? null
          : DateTime.parse(json['pump_on_date'] ?? ''),
      pumpOffDate: json['pump_off_date'] == null
          ? null
          : DateTime.parse(json['pump_off_date'] ?? ''),
      waterDrainStartDate: json['water_drain_start_date'] == null
          ? null
          : DateTime.parse(json['water_drain_start_date'] ?? ''),
      waterDrainEndDate: json['water_drain_end_date'] == null
          ? null
          : DateTime.parse(json['water_drain_end_date'] ?? ''),
    );
  }
}
