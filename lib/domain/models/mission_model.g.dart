// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionModel _$MissionModelFromJson(Map<String, dynamic> json) => MissionModel(
  id: json['id'] as String,
  missionNumber: json['missionNumber'] as String,
  emergencyType: $enumDecode(_$EmergencyTypeEnumMap, json['emergencyType']),
  status: $enumDecode(_$MissionStatusEnumMap, json['status']),
  patientId: json['patientId'] as String,
  ambulanceId: json['ambulanceId'] as String,
  clinicId: json['clinicId'] as String,
  clinicName: json['clinicName'] as String,
  clinicAddress: json['clinicAddress'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  isLocked: json['isLocked'] as bool? ?? false,
  isSuperAdminLocked: json['isSuperAdminLocked'] as bool? ?? false,
  driverId: json['driverId'] as String?,
  emtId: json['emtId'] as String?,
  doctorId: json['doctorId'] as String?,
  nurseId: json['nurseId'] as String?,
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => MissionTimeline.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MissionModelToJson(MissionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'missionNumber': instance.missionNumber,
      'emergencyType': _$EmergencyTypeEnumMap[instance.emergencyType]!,
      'status': _$MissionStatusEnumMap[instance.status]!,
      'patientId': instance.patientId,
      'ambulanceId': instance.ambulanceId,
      'clinicId': instance.clinicId,
      'clinicName': instance.clinicName,
      'clinicAddress': instance.clinicAddress,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'isLocked': instance.isLocked,
      'isSuperAdminLocked': instance.isSuperAdminLocked,
      'driverId': instance.driverId,
      'emtId': instance.emtId,
      'doctorId': instance.doctorId,
      'nurseId': instance.nurseId,
      'timeline': instance.timeline,
    };

const _$EmergencyTypeEnumMap = {
  EmergencyType.cardiac: 'cardiac',
  EmergencyType.trauma: 'trauma',
  EmergencyType.respiratory: 'respiratory',
  EmergencyType.neurological: 'neurological',
  EmergencyType.other: 'other',
};

const _$MissionStatusEnumMap = {
  MissionStatus.assigned: 'assigned',
  MissionStatus.enRoute: 'en_route',
  MissionStatus.onScene: 'on_scene',
  MissionStatus.transporting: 'transporting',
  MissionStatus.atClinic: 'at_clinic',
  MissionStatus.completed: 'completed',
  MissionStatus.cancelled: 'cancelled',
};

MissionTimeline _$MissionTimelineFromJson(Map<String, dynamic> json) =>
    MissionTimeline(
      status: $enumDecode(_$MissionStatusEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MissionTimelineToJson(MissionTimeline instance) =>
    <String, dynamic>{
      'status': _$MissionStatusEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'notes': instance.notes,
    };
