import 'package:flutter/services.dart';

class FarmlandUpdateBasicInfoRequest {
  final int farmlandId;
  final Uint8List photo;
  final double latitude;
  final double longitude;

  FarmlandUpdateBasicInfoRequest({
    required this.farmlandId,
    required this.photo,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmland_id': farmlandId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
