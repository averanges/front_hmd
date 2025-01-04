import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';

class AwdChangeData {
  final int id;
  final ChangeRequestStatus status;
  final DateTime createdAt;

  AwdChangeData({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory AwdChangeData.fromJson(Map<String, dynamic> json) {
    return AwdChangeData(
      id: json['awd_change_id'],
      status: json['status'] != null
          ? ChangeRequestStatus.from(json['status'])
          : ChangeRequestStatus.pending,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'awd_change_id': id,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PumpChangeData {
  final int id;
  final ChangeRequestStatus status;
  final DateTime createdAt;

  PumpChangeData({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory PumpChangeData.fromJson(Map<String, dynamic> json) {
    return PumpChangeData(
      id: json['pump_change_id'],
      status: json['status'] != null
          ? ChangeRequestStatus.from(json['status'])
          : ChangeRequestStatus.pending,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pump_change_id': id,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum ChangeRequestStatus {
  pending, // 승인중
  approved, // 승이완료
  rejected; // 승인거절

  String get displayName {
    switch (this) {
      case ChangeRequestStatus.pending:
        return 'change_request_status_pending'.tr; //'승인 중';
      case ChangeRequestStatus.approved:
        return 'change_request_status_approved'.tr; //'승인완료';
      case ChangeRequestStatus.rejected:
        return 'change_request_status_rejected'.tr; //'승인거절';
    }
  }

  Color get color {
    switch (this) {
      case ChangeRequestStatus.pending:
        return AppColors.farmlandStatusPending;
      case ChangeRequestStatus.approved:
        return AppColors.farmlandStatusApproved;
      case ChangeRequestStatus.rejected:
        return AppColors.farmlandStatusRejected;
    }
  }

  factory ChangeRequestStatus.from(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return ChangeRequestStatus.pending;
      case 'APPROVED':
        return ChangeRequestStatus.approved;
      case 'REJECTED':
        return ChangeRequestStatus.rejected;
      default:
        return ChangeRequestStatus.pending;
    }
  }
}
