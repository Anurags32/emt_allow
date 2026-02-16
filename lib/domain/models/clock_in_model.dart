import 'package:json_annotation/json_annotation.dart';

part 'clock_in_model.g.dart';

enum ClockStatus {
  @JsonValue('clocked_in')
  clockedIn,
  @JsonValue('clocked_out')
  clockedOut,
  @JsonValue('on_break')
  onBreak,
}

@JsonSerializable()
class ClockInModel {
  final String id;
  final String userId;
  final String? ambulanceId;
  final ClockStatus status;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final String? doctorId;
  final String? nurseId;
  final bool isValidated;

  ClockInModel({
    required this.id,
    required this.userId,
    this.ambulanceId,
    required this.status,
    required this.clockInTime,
    this.clockOutTime,
    this.doctorId,
    this.nurseId,
    this.isValidated = false,
  });

  factory ClockInModel.fromJson(Map<String, dynamic> json) =>
      _$ClockInModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClockInModelToJson(this);
}

@JsonSerializable()
class TeamMember {
  final String id;
  final String name;
  final String role;
  final String employeeId;
  final bool isAvailable;
  final String? currentAmbulanceId;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.employeeId,
    this.isAvailable = true,
    this.currentAmbulanceId,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberToJson(this);
}
