import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  final String shift;
  final String date;
  @JsonKey(name: 'ambulance_type_name')
  final String ambulanceTypeName;
  @JsonKey(name: 'ambulance_id')
  final int ambulanceId;
  @JsonKey(name: 'ambulance_name')
  final String ambulanceName;
  @JsonKey(name: 'driver_id')
  final dynamic driverId; // Can be int or false
  @JsonKey(name: 'driver_name')
  final dynamic driverName; // Can be string or false
  @JsonKey(name: 'emt_id')
  final dynamic emtId; // Can be int or false
  @JsonKey(name: 'emt_name')
  final dynamic emtName; // Can be string or false
  @JsonKey(name: 'nurse_id')
  final dynamic nurseId; // Can be int or false
  @JsonKey(name: 'nurse_name')
  final dynamic nurseName; // Can be string or false
  @JsonKey(name: 'doctor_id')
  final dynamic doctorId; // Can be int or false
  @JsonKey(name: 'doctor_name')
  final dynamic doctorName; // Can be string or false

  ScheduleModel({
    required this.shift,
    required this.date,
    required this.ambulanceTypeName,
    required this.ambulanceId,
    required this.ambulanceName,
    this.driverId,
    this.driverName,
    this.emtId,
    this.emtName,
    this.nurseId,
    this.nurseName,
    this.doctorId,
    this.doctorName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  // Helper getters for safe string access
  String get driverNameSafe =>
      (driverName is String) ? driverName as String : 'No Driver';
  String get emtNameSafe => (emtName is String) ? emtName as String : 'No EMT';
  String get nurseNameSafe =>
      (nurseName is String) ? nurseName as String : 'No Nurse';
  String get doctorNameSafe =>
      (doctorName is String) ? doctorName as String : 'No Doctor';

  // Shift display name
  String get shiftDisplayName {
    switch (shift.toLowerCase()) {
      case 'morning':
        return 'Morning Shift';
      case 'afternoon':
        return 'Afternoon Shift';
      case 'evening':
        return 'Evening Shift';
      case 'night':
        return 'Night Shift';
      default:
        return shift;
    }
  }

  // Parse ambulance details
  String get ambulanceVehicle {
    final parts = ambulanceName.split('/');
    return parts.isNotEmpty ? parts[0] : ambulanceName;
  }

  String get ambulanceModel {
    final parts = ambulanceName.split('/');
    return parts.length > 1 ? parts[1] : '';
  }

  String get ambulancePlate {
    final parts = ambulanceName.split('/');
    return parts.length > 2 ? parts[2] : '';
  }
}
