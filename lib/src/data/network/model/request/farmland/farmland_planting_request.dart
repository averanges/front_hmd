class FarmlandPlantingRequest {
  final int farmlandId;
  final DateTime plantingDate;
  final String plantingMethod;
  final String riceCultivar;

  FarmlandPlantingRequest({
    required this.farmlandId,
    required this.plantingDate,
    required this.plantingMethod,
    required this.riceCultivar,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmland_id': farmlandId,
      'planting_date': plantingDate.toIso8601String(),
      'planting_method': plantingMethod,
      'rice_cultivar': riceCultivar,
    };
  }
}
