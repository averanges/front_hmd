class FarmlandRecordData {
  final bool watering;
  final bool pumpOnRecord;
  final bool pumpOffRecord;
  final bool fertilizer;
  final bool pesticide;
  final bool harvest;
  final String diary;
  final DateTime targetDate;

  FarmlandRecordData({
    required this.watering,
    required this.pumpOnRecord,
    required this.pumpOffRecord,
    required this.fertilizer,
    required this.pesticide,
    required this.harvest,
    required this.diary,
    required this.targetDate,
  });

  factory FarmlandRecordData.fromJson(
    Map<String, dynamic> json,
    DateTime targetDate,
  ) {
    return FarmlandRecordData(
      watering: json['watering'] ?? false,
      pumpOnRecord: json['pumpOnRecord'] ?? false,
      pumpOffRecord: json['pumpOffRecord'] ?? false,
      fertilizer: json['fertilizer'] ?? false,
      pesticide: json['pesticide'] ?? false,
      harvest: json['harvest'] ?? false,
      diary: json['diary'] ?? '',
      targetDate: targetDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watering': watering,
      'pumpOnRecord': pumpOnRecord,
      'pumpOffRecord': pumpOffRecord,
      'fertilizer': fertilizer,
      'pesticide': pesticide,
      'harvest': harvest,
      'diary': diary,
    };
  }
}
