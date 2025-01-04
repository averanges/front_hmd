import 'package:equatable/equatable.dart';
import 'package:haimdall/src/presentation/common/component/haimdall_dropdown/haimdall_dropdown.dart';

class ProjectInfo extends Equatable implements HaimdallDropdownData {
  final int projectId;
  final String projectName;
  final String countryName;
  final ProjectStatus status;

  const ProjectInfo({
    required this.projectId,
    required this.projectName,
    required this.countryName,
    required this.status,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      projectId: json['project_id'] ?? -1,
      projectName: json['project_name'] ?? '',
      countryName: json['country_name'] ?? '',
      status: ProjectStatus.fromString(json['status'] ?? ''),
    );
  }

  @override
  List<Object?> get props => [projectId];

  @override
  String toName() => projectName;

  @override
  String toApiValue() {
    return projectId.toString();
  }
}

enum ProjectStatus {
  preparing, // 준비중
  inProgress, // 수행중
  completed; // 완료

  static ProjectStatus fromString(String status) {
    switch (status) {
      case 'PREPARING':
        return ProjectStatus.preparing;
      case 'IN_PROGRESS':
        return ProjectStatus.inProgress;
      case 'COMPLETED':
        return ProjectStatus.completed;
      default:
        return ProjectStatus.preparing;
    }
  }
}

extension ProjectStatusExtension on ProjectStatus {
  String get value {
    switch (this) {
      case ProjectStatus.preparing:
        return 'PREPARING';
      case ProjectStatus.inProgress:
        return 'IN_PROGRESS';
      case ProjectStatus.completed:
        return 'COMPLETED';
    }
  }
}
