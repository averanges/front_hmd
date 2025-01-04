import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';

class Farmland {
  final int farmlandId;
  final String ownerName;
  final double latitude;
  final double longitude;
  final FarmlandStatus status;
  final String currentStep;

  Farmland({
    required this.farmlandId,
    required this.ownerName,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.currentStep,
  });

  factory Farmland.fromJson(Map<String, dynamic> json) {
    final latitude = json['latitude'];
    final longitude = json['longitude'];

    return Farmland(
      farmlandId: json['farmland_id'] ?? -1,
      ownerName: json['owner_name'] ?? '',
      latitude: latitude == null
          ? 0.0
          : latitude is String
              ? double.tryParse(latitude)
              : latitude ?? 0.0,
      longitude: longitude == null
          ? 0.0
          : longitude is String
              ? double.tryParse(longitude)
              : longitude ?? 0.0,
      status: FarmlandStatus.fromString(json['status'] ?? ''),
      currentStep: json['current_step'] ?? '',
    );
  }
}

enum FarmlandStatus {
  completed,
  approved,
  photoRequired,
  rejected,
  pending;

  static FarmlandStatus fromString(String status) {
    switch (status) {
      case 'COMPLETED':
        return FarmlandStatus.completed;
      case 'APPROVED':
        return FarmlandStatus.approved;
      case 'PHOTO_REQUIRED':
        return FarmlandStatus.photoRequired;
      case 'REJECTED':
        return FarmlandStatus.rejected;
      case 'PENDING':
        return FarmlandStatus.pending;
      default:
        return FarmlandStatus.pending;
    }
  }

  String get name {
    switch (this) {
      case FarmlandStatus.completed:
        return 'farmland_status_completed'.tr; //'수행완료';
      case FarmlandStatus.approved:
        return 'farmland_status_approved'.tr; //'승인완료';
      case FarmlandStatus.photoRequired:
        return 'farmland_status_photo_required'.tr; //'사진필요';
      case FarmlandStatus.rejected:
        return 'farmland_status_rejected'.tr; //'승인거절';
      case FarmlandStatus.pending:
        return 'farmland_status_pending'.tr; // '승인 중';
    }
  }

  Color get color => switch (this) {
    FarmlandStatus.approved => AppColors.farmlandStatusApproved,
    FarmlandStatus.photoRequired => AppColors.farmlandStatusRequiredPhoto,
    FarmlandStatus.rejected => AppColors.farmlandStatusRejected,
    FarmlandStatus.pending => AppColors.farmlandStatusPending,
    FarmlandStatus.completed => AppColors.farmlandStatusCompleted,
  };
}
