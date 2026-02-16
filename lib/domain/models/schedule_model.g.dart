// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      shift: json['shift'] as String,
      date: json['date'] as String,
      ambulanceTypeName: json['ambulance_type_name'] as String,
      ambulanceId: (json['ambulance_id'] as num).toInt(),
      ambulanceName: json['ambulance_name'] as String,
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      emtId: json['emt_id'],
      emtName: json['emt_name'],
      nurseId: json['nurse_id'],
      nurseName: json['nurse_name'],
      doctorId: json['doctor_id'],
      doctorName: json['doctor_name'],
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'shift': instance.shift,
      'date': instance.date,
      'ambulance_type_name': instance.ambulanceTypeName,
      'ambulance_id': instance.ambulanceId,
      'ambulance_name': instance.ambulanceName,
      'driver_id': instance.driverId,
      'driver_name': instance.driverName,
      'emt_id': instance.emtId,
      'emt_name': instance.emtName,
      'nurse_id': instance.nurseId,
      'nurse_name': instance.nurseName,
      'doctor_id': instance.doctorId,
      'doctor_name': instance.doctorName,
    };
