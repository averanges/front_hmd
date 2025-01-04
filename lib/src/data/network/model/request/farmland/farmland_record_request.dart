class FarmlandRecordRequest {
  int farmlandId;
  DateTime targetDate;
  String? fertilizerType;
  double? fertilizerAmount;
  String? pesticideType;
  double? pesticideAmount;
  double? harvestAmount;
  String? diary;

  FarmlandRecordRequest({
    required this.farmlandId,
    required this.targetDate,
    this.fertilizerType,
    this.fertilizerAmount,
    this.pesticideType,
    this.pesticideAmount,
    this.harvestAmount,
    this.diary,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['farmland_id'] = farmlandId;
    data['target_date'] = targetDate.toIso8601String();
    if (fertilizerType != null) {
      data['fertilizer_type'] = fertilizerType;
    }
    if (fertilizerAmount != null) {
      data['fertilizer_amount'] = fertilizerAmount;
    }
    if (pesticideType != null) {
      data['pesticide_type'] = pesticideType;
    }
    if (pesticideAmount != null) {
      data['pesticide_amount'] = pesticideAmount;
    }
    if (harvestAmount != null) {
      data['harvest_amount'] = harvestAmount;
    }
    if (diary != null) {
      data['diary'] = diary;
    }
    return data;
  }
}
