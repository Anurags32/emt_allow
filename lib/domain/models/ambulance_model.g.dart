// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambulance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbulanceModel _$AmbulanceModelFromJson(Map<String, dynamic> json) =>
    AmbulanceModel(
      id: json['id'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      type: $enumDecode(_$AmbulanceTypeEnumMap, json['type']),
      status: $enumDecode(_$AmbulanceStatusEnumMap, json['status']),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
    );

Map<String, dynamic> _$AmbulanceModelToJson(AmbulanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleNumber': instance.vehicleNumber,
      'type': _$AmbulanceTypeEnumMap[instance.type]!,
      'status': _$AmbulanceStatusEnumMap[instance.status]!,
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
    };

const _$AmbulanceTypeEnumMap = {
  AmbulanceType.basic: 'basic',
  AmbulanceType.advanced: 'advanced',
  AmbulanceType.critical: 'critical',
};

const _$AmbulanceStatusEnumMap = {
  AmbulanceStatus.available: 'available',
  AmbulanceStatus.assigned: 'assigned',
  AmbulanceStatus.onMission: 'on_mission',
  AmbulanceStatus.maintenance: 'maintenance',
};
