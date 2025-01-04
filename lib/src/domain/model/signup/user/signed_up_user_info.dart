class SignedUpUserInfo {
  final String name;
  final UserStatus status;
  final bool completedTutorial;
  final bool alarmControlled;

  SignedUpUserInfo({
    required this.name,
    required this.status,
    required this.completedTutorial,
    required this.alarmControlled,
  });

  factory SignedUpUserInfo.fromJson(Map<String, dynamic> json) {
    return SignedUpUserInfo(
      name: json['name'] ?? '',
      status: UserStatus.fromString(json['status'] ?? ''),
      completedTutorial: json['completed_tutorial'] ?? false,
      alarmControlled: json['alarm_controlled'] ?? false,
    );
  }
}

enum UserStatus {
  approved,
  rejected,
  pending,
  unrequested;

  String get value {
    switch (this) {
      case UserStatus.approved:
        return 'APPROVED';
      case UserStatus.rejected:
        return 'REJECTED';
      case UserStatus.pending:
        return 'PENDING';
      case UserStatus.unrequested:
        return 'UNREQUESTED';
    }
  }

  static UserStatus fromString(String value) {
    switch (value) {
      case 'APPROVED':
        return UserStatus.approved;
      case 'REJECTED':
        return UserStatus.rejected;
      case 'PENDING':
        return UserStatus.pending;
      case 'UNREQUESTED':
        return UserStatus.unrequested;
      default:
        return UserStatus.unrequested;
    }
  }
}
