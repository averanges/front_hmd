class FarmlandRecordingStatus {
  final bool watering;
  final bool fertilizer;
  final bool pesticide;
  final bool harvest;
  final bool diary;

  FarmlandRecordingStatus({
    required this.watering,
    required this.fertilizer,
    required this.pesticide,
    required this.harvest,
    required this.diary,
  });

  factory FarmlandRecordingStatus.fromJson(Map<String, dynamic> json) {
    return FarmlandRecordingStatus(
      watering: json['watering'] ?? false,
      fertilizer: json['fertilizer'] ?? false,
      pesticide: json['pesticide'] ?? false,
      harvest: json['harvest'] ?? false,
      diary: json['diary'] ?? false,
    );
  }
}
