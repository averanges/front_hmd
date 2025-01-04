// 물배기 기록 API (PATCH)
import 'package:flutter/services.dart';

class FarmlandDrainWaterRequest {
  final int wateringId;
  final int farmlandId;
  final double latitude;
  final double longitude;
  final DateTime recordTime;
  final Uint8List photo;

  FarmlandDrainWaterRequest({
    required this.wateringId,
    required this.farmlandId,
    required this.latitude,
    required this.longitude,
    required this.recordTime,
    required this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      'watering_id': wateringId,
      'farmland_id': farmlandId,
      'latitude': latitude,
      'longitude': longitude,
      'record_time': recordTime.toIso8601String(),
    };
  }
}
