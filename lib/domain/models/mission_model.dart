import 'package:json_annotation/json_annotation.dart';

part 'mission_model.g.dart';

enum MissionStatus {
  @JsonValue('assigned')
  assigned,
  @JsonValue('en_route')
  enRoute,
  @JsonValue('on_scene')
  onScene,
  @JsonValue('transporting')
  transporting,
  @JsonValue('at_clinic')
  atClinic,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum EmergencyType {
  @JsonValue('cardiac')
  cardiac,
  @JsonValue('trauma')
  trauma,
  @JsonValue('respiratory')
  respiratory,
  @JsonValue('neurological')
  neurological,
  @JsonValue('other')
  other,
}

@JsonSerializable()
class MissionModel {
  final String id;
  final String missionNumber;
  final EmergencyType emergencyType;
  final MissionStatus status;
  final String patientId;
  final String ambulanceId;
  final String clinicId;
  final String clinicName;
  final String clinicAddress;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isLocked;
  final bool isSuperAdminLocked;
  final String? driverId;
  final String? emtId;
  final String? doctorId;
  final String? nurseId;
  final List<MissionTimeline> timeline;

  MissionModel({
    required this.id,
    required this.missionNumber,
    required this.emergencyType,
    required this.status,
    required this.patientId,
    required this.ambulanceId,
    required this.clinicId,
    required this.clinicName,
    required this.clinicAddress,
    required this.createdAt,
    this.completedAt,
    this.isLocked = false,
    this.isSuperAdminLocked = false,
    this.driverId,
    this.emtId,
    this.doctorId,
    this.nurseId,
    this.timeline = const [],
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MissionModelToJson(this);

  String get emergencyTypeDisplayName {
    switch (emergencyType) {
      case EmergencyType.cardiac:
        return 'Cardiac Emergency';
      case EmergencyType.trauma:
        return 'Trauma';
      case EmergencyType.respiratory:
        return 'Respiratory Emergency';
      case EmergencyType.neurological:
        return 'Neurological Emergency';
      case EmergencyType.other:
        return 'Other Emergency';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case MissionStatus.assigned:
        return 'Assigned';
      case MissionStatus.enRoute:
        return 'En Route';
      case MissionStatus.onScene:
        return 'On Scene';
      case MissionStatus.transporting:
        return 'Transporting';
      case MissionStatus.atClinic:
        return 'At Clinic';
      case MissionStatus.completed:
        return 'Completed';
      case MissionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

@JsonSerializable()
class MissionTimeline {
  final MissionStatus status;
  final DateTime timestamp;
  final String? notes;

  MissionTimeline({required this.status, required this.timestamp, this.notes});

  factory MissionTimeline.fromJson(Map<String, dynamic> json) =>
      _$MissionTimelineFromJson(json);

  Map<String, dynamic> toJson() => _$MissionTimelineToJson(this);
}
