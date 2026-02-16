// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockInModel _$ClockInModelFromJson(Map<String, dynamic> json) => ClockInModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  ambulanceId: json['ambulanceId'] as String?,
  status: $enumDecode(_$ClockStatusEnumMap, json['status']),
  clockInTime: DateTime.parse(json['clockInTime'] as String),
  clockOutTime: json['clockOutTime'] == null
      ? null
      : DateTime.parse(json['clockOutTime'] as String),
  doctorId: json['doctorId'] as String?,
  nurseId: json['nurseId'] as String?,
  isValidated: json['isValidated'] as bool? ?? false,
);

Map<String, dynamic> _$ClockInModelToJson(ClockInModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'ambulanceId': instance.ambulanceId,
      'status': _$ClockStatusEnumMap[instance.status]!,
      'clockInTime': instance.clockInTime.toIso8601String(),
      'clockOutTime': instance.clockOutTime?.toIso8601String(),
      'doctorId': instance.doctorId,
      'nurseId': instance.nurseId,
      'isValidated': instance.isValidated,
    };

const _$ClockStatusEnumMap = {
  ClockStatus.clockedIn: 'clocked_in',
  ClockStatus.clockedOut: 'clocked_out',
  ClockStatus.onBreak: 'on_break',
};

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => TeamMember(
  id: json['id'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
  employeeId: json['employeeId'] as String,
  isAvailable: json['isAvailable'] as bool? ?? true,
  currentAmbulanceId: json['currentAmbulanceId'] as String?,
);

Map<String, dynamic> _$TeamMemberToJson(TeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'employeeId': instance.employeeId,
      'isAvailable': instance.isAvailable,
      'currentAmbulanceId': instance.currentAmbulanceId,
    };
